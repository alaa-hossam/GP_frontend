import 'package:flutter/material.dart';
import '../widgets/Dimensions.dart';
import 'ProfileView.dart';

class browseProducts extends StatefulWidget {
  static String id = "browseProductsScreen";

  const browseProducts({super.key});
  @override
  State<browseProducts> createState() => _browseProductsState();
}

class _browseProductsState extends State<browseProducts> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
                  size:24 * SizeConfig.textRatio,
                ),
                SizedBox(
                  width: 10 * SizeConfig.horizontalBlock,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Profile.id);
                  },
                  icon: Icon(Icons.account_circle_outlined, size:24 * SizeConfig.textRatio,),
                ),
              ],
            ),
          )
        ],
        title: Text("Logo"),
      ),
    );
  }
}
