import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:gp_frontend/widgets/compareColumn.dart';

import '../widgets/Dimensions.dart';

class compareScreen extends StatefulWidget {
  static String id = "compareScreen";

  @override
  State<compareScreen> createState() => _compareScreenState();
}

class _compareScreenState extends State<compareScreen> {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
      return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 85 * SizeConfig.verticalBlock, // Set the height of the AppBar
        flexibleSpace: Container(
          decoration:const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF223F4A), // Start color
                Color(0xFF5095B0), // End color
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20), // Rounded bottom-left corner
              bottomRight: Radius.circular(20), // Rounded bottom-right corner
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: SizeConfig.textRatio * 15,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Compare Between',
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 20 * SizeConfig.textRatio,
            fontWeight: FontWeight.bold
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), // Rounded bottom-left corner
            bottomRight: Radius.circular(20), // Rounded bottom-right corner
          ),
        ),
      ),
      body: arguments is List
      ?
        // padding:  EdgeInsets.all(10.0 * SizeConfig.verticalBlock),
        ListView.builder(
          itemCount: arguments.length,
          scrollDirection: Axis.horizontal,// Use the length of the list
          itemBuilder: (context, index) {
            productModel product = arguments[index]; // Access each item in the list
            return Padding(
              padding:  EdgeInsets.all(8.0 * SizeConfig.verticalBlock),
              child: compareColumn(product.id, product.imageURL,product.name,
                  product.category,product.price,product.rate),
            );
          },
        )
      : Center(child: Text("No items")),
    );
  }
}
