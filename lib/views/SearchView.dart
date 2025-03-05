import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/ViewModels/productViewModel.dart';

import '../widgets/Dimensions.dart';
import '../widgets/customizeTextFormField.dart';
import 'ProfileView.dart';

class searchView extends StatefulWidget {
  static String id = "searchScreen";

  const searchView({super.key});

  @override
  State<searchView> createState() => _searchState();
}

class _searchState extends State<searchView> {

  late FocusNode _focusNode;
  productViewModel PVM= productViewModel();
  List<String>? products;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController search = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.menu),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20 * SizeConfig.verticalBlock),
            child: Row(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 24 * SizeConfig.textRatio,
                ),
                SizedBox(
                  width: 10 * SizeConfig.horizontalBlock,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Profile.id);
                  },
                  icon: Icon(
                    Icons.account_circle_outlined,
                    size: 24 * SizeConfig.textRatio,
                  ),
                ),
              ],
            ),
          )
        ],
        title: Text("Logo"),
      ),

      body:
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
              width: 300 * SizeConfig.horizontalBlock,
              height: 45 * SizeConfig.verticalBlock,
            onChanged: (value) async{
              // Call the API whenever the text changes
             products = await PVM.searchProduct(value);
             print("Products:");
             print(products);

            },


          ),
          SizedBox(width: 20 * SizeConfig.horizontalBlock),
          Container(
            width: 48 * SizeConfig.horizontalBlock,
            height: 45 * SizeConfig.verticalBlock,
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Icon(
              Icons.tune,
              size: 24 * SizeConfig.textRatio,
            ),
          ),
          // MyTextFormField(
          //   controller: filter,
          //   icon: Icons.tune,
          //   width: 48 * SizeConfig.horizontalBlock,
          //   height: 45 * SizeConfig.verticalBlock,
          // )
        ],
      ),


    );
  }
}
