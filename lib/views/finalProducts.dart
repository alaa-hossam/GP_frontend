import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';

class FinalProduct extends StatefulWidget {
  static String id = "AddFinalProductScreen";
  final productModel product;

  const FinalProduct({super.key , required this.product});

  @override
  State<FinalProduct> createState() => _FinalProductState();
}

class _FinalProductState extends State<FinalProduct> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 85 * SizeConfig.verticalBlock,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF223F4A),
                Color(0xFF5095B0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
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
          'Final Products',
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 20 * SizeConfig.textRatio,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15 * SizeConfig.horizontalBlock,
          vertical: 10 * SizeConfig.verticalBlock,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if( widget.product.finalProducts == null) ...[
              Text("There are no final products yet.",
                style: TextStyle(
                fontSize: 24 * SizeConfig.textRatio,
                fontWeight: FontWeight.bold,
                  fontFamily: "Rubik",
                  color: Color(0xFF3C3C3C).withOpacity(0.5),
              ),),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 2,
              children: [
                CircleAvatar(
                  radius: SizeConfig.horizontalBlock * 20,
                  backgroundColor: SizeConfig.secondColor,
                  foregroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(Icons.add, size: SizeConfig.horizontalBlock * 20),
                    onPressed: (){},
                  ),
                ),
                Text("Add final product",
                  style: TextStyle(
                    fontSize: 20 * SizeConfig.textRatio,
                    fontFamily: "Roboto",
                  ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
