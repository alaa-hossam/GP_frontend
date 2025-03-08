import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/ViewModels/productViewModel.dart';
import '../widgets/Dimensions.dart';
import '../widgets/customizeTextFormField.dart';
import 'ProfileView.dart';
import 'dart:async'; // Import Timer

class searchView extends StatefulWidget {
  static String id = "searchScreen";

  const searchView({super.key});

  @override
  State<searchView> createState() => _searchState();
}

class _searchState extends State<searchView> {
  late FocusNode _focusNode;
  productViewModel PVM = productViewModel();
  List<dynamic>? products;
  TextEditingController search = TextEditingController();
  Timer? _debounceTimer; // Timer for debouncing

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    search.dispose();
    _debounceTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Function to handle debounced search
  void _onSearchTextChanged(String value) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel(); // Cancel the previous timer if it's active
    }

    // Start a new timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      // This code runs only if the user hasn't typed anything new within 500ms
      products = await PVM.searchProduct(value);
      setState(() {}); // Update the UI with the new results
      print("Products:");
      print(products);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        toolbarHeight: 119 * SizeConfig.verticalBlock, // Set the height of the AppBar
        flexibleSpace: Container(
          height: 119,
          decoration:const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF223F4A), // Start color
                Color(0xFF5095B0), // End color
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),

          ),
          child:
          Padding(
            padding:  EdgeInsets.only(left: 8.0 * SizeConfig.textRatio , bottom: 8.0 * SizeConfig.textRatio ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MyTextFormField(

                  autofocus: true,
                  focusNode: _focusNode,
                  controller: search,
                  hintName: "Search",
                  icon: Icons.search,
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      color: SizeConfig.iconColor,
                      size: 24 * SizeConfig.textRatio,
                    ),
                    onPressed: () {
                      // Handle camera icon press
                    },
                  ),
                  width: 336 * SizeConfig.horizontalBlock,
                  height: 45 * SizeConfig.verticalBlock,
                  onChanged: (value) {
                    _onSearchTextChanged(value); // Pass the value to the debounced function
                  },
                ),
            ],
            ),
          ),

        ),
        leading: Padding(
          padding:  EdgeInsets.only(right: 20.0 * SizeConfig.textRatio , bottom: 12.0 * SizeConfig.textRatio),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: SizeConfig.textRatio * 15,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),


      ),

      body: ListView(
        children: [
          SizedBox(height: 20 * SizeConfig.verticalBlock), // Add some spacing
          if (products != null && products!.isNotEmpty)
            ListView.builder(
              shrinkWrap: true, // Ensure the ListView takes only the required space
              physics: NeverScrollableScrollPhysics(), // Disable scrolling inside ListView
              itemCount: products!.length,
              itemBuilder: (context, index) {
                final product = products![index];
                return ListTile(
                  title: Text(product['name'] ?? 'No Name'),
                  leading: product['imageUrl'] != null
                      ? Image.network(product['imageUrl'], width: 45, height: 45) // Replace 'imageUrl' with your product's image field
                      : Icon(Icons.image),
                  onTap: () {
                    // Handle product tap (e.g., navigate to product details)
                  },
                );
              },
            )
          else if (products != null && products!.isEmpty)
            Center(
              child: Text(
                "No products found.",
                style: TextStyle(fontSize: 16 * SizeConfig.textRatio),
              ),
            ),
        ],
      ),
    );
  }
}