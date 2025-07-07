import 'package:flutter/material.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:gp_frontend/widgets/orderContainer.dart';
import 'package:provider/provider.dart';
import '../Providers/orderProvider.dart';
import '../widgets/OrdersAppBar.dart';

class showOrders extends StatefulWidget {
  static String id = "ShowOrders";
  const showOrders({super.key});

  @override
  State<showOrders> createState() => _showOrdersState();
}

class _showOrdersState extends State<showOrders> {
  int selectedIndex = 0;
  late Future<List<Map<String, dynamic>>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = Provider.of<orderProvider>(context, listen: false)
        .getOrders(); // No filter here
  }

  List<Map<String, dynamic>> filterOrders(
      List<Map<String, dynamic>> allOrders) {
    List<String> activeStatuses = [
      'Pending',
      'Preparing',
      'Ready',
      'Delivering'
    ];
    List<String> completedStatuses = ['Completed'];
    List<String> cancelledStatuses = ['Canceled'];

    if (selectedIndex == 0) {
      return allOrders
          .where((order) => activeStatuses.contains(order['status']))
          .toList();
    } else if (selectedIndex == 1) {
      return allOrders
          .where((order) => completedStatuses.contains(order['status']))
          .toList();
    } else {
      return allOrders
          .where((order) => cancelledStatuses.contains(order['status']))
          .toList();
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrdersAppBar(index: selectedIndex, onTabSelected: _onTabSelected),
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
            if (filteredOrders.isEmpty) {
              return const Center(child: Text("No orders for this category."));
            }
            return Padding(
              padding: EdgeInsets.only(
                  top: 30.0 * SizeConfig.verticalBlock,
                  right: 10 * SizeConfig.horizontalBlock,
                  left: 10 * SizeConfig.horizontalBlock),
              child: ListView.builder(
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return OrderContainer(order: order,isCrafter: false,);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
