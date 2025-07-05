import 'package:flutter/material.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:provider/provider.dart';

import '../Providers/orderProvider.dart';
import '../widgets/crafterOrdersAppBar.dart';
import '../widgets/orderContainer.dart';

class ShowCrafterOrders extends StatefulWidget {
  static String id = "ShowCrafterOrdersScreen";
  const ShowCrafterOrders({super.key});

  @override
  State<ShowCrafterOrders> createState() => _ShowCrafterOrdersState();
}

class _ShowCrafterOrdersState extends State<ShowCrafterOrders> {
  int selectedIndex = 0;
  late Future<List<Map<String, dynamic>>> _ordersFuture;
  int subFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    _ordersFuture = Provider.of<orderProvider>(context, listen: false).getCrafterOrders(); // No filter here
  }

  List<Map<String, dynamic>>? filterOrders(List<Map<String, dynamic>> allOrders) {
    List<String> activeStatuses = ['Pending', 'Preparing', 'Ready', 'Delivering'];
    List<String> completedStatuses = ['Completed'];

    if (selectedIndex == 0) {
      return allOrders.where((order) => completedStatuses.contains(order['status'])).toList();
    } else if (selectedIndex == 1) {
      // Apply additional filtering when Active tab is selected
      List<Map<String, dynamic>> activeOrders = allOrders
          .where((order) => activeStatuses.contains(order['status']))
          .toList();

      if (subFilterIndex == 0) {
        // Custom
        return activeOrders.where((order) => order['type'] == "CustomMade").toList();
      } else if (subFilterIndex == 1) {
        // From posts
        return activeOrders.where((order) => order['type'] == "PostCustomized").toList();
      }
    }

    return [];
  }

  void _onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: CrafterOrdersAppBar(index: selectedIndex, onTabSelected: _onTabSelected),
      body: FutureBuilder<List<Map<String, dynamic>>>(
    future: _ordersFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("No orders found."));
      } else {
        final filteredOrders = filterOrders(snapshot.data!);
        if (filteredOrders!.isEmpty) {
          return const Center(child: Text("No orders for this category."));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedIndex == 1) ...
              [
                SizedBox(height: 40 * SizeConfig.verticalBlock),
                Divider(
                  height: 2,
                  indent: 40 * SizeConfig.horizontalBlock,
                  endIndent: 40 * SizeConfig.horizontalBlock,

                ),
                Padding(
                padding: EdgeInsets.symmetric(horizontal: 16 * SizeConfig.horizontalBlock,vertical: 16 * SizeConfig.verticalBlock),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    toggleSubFilter("Custom", 0),
                    SizedBox(width: 10),
                    toggleSubFilter("From posts", 1),
                  ],
                ),
              ),
              ],
            SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10 * SizeConfig.horizontalBlock),
                child: ListView.builder(
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    return OrderContainer(order: order,isCrafter: true,);
                  },
                ),
              ),
            ),
          ],
        );
      }
    },
    ),
    );
  }
  Widget toggleSubFilter(String title, int index) {
    final isSelected = subFilterIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          subFilterIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? SizeConfig.iconColor : Colors.white,
          border: Border.all(color: SizeConfig.iconColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : SizeConfig.iconColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}
