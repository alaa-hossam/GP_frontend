import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:gp_frontend/views/BazarProductsReview.dart';
import 'package:provider/provider.dart';

import '../Providers/ProductProvider.dart';
import '../widgets/Dimensions.dart';
import '../widgets/customizeTextFormField.dart';

class BazarVariations extends StatefulWidget {
  static String id = "bazarVariations";
  const BazarVariations({super.key});

  @override
  State<BazarVariations> createState() => _BazarVariationsState();
}

class _BazarVariationsState extends State<BazarVariations> {
  int index = 0; // Declare index as an instance variable

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as List<String>;
    var prodProvider = Provider.of<productProvider>(context, listen: false);
    List<productModel> products = [];
    TextEditingController offer = TextEditingController();

    Future<void> getProducts() async {
      products = await prodProvider.productVariation(arguments);
    }

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
          'Join Bazar',
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
        padding: EdgeInsets.all(10 * SizeConfig.verticalBlock),
        child: FutureBuilder<void>(
          future: getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error loading product details"));
            } else {
              return ListView(
                children: [
                  SizedBox(
                    height: 580 * SizeConfig.verticalBlock,
                    child: ListView(
                      children: [
                        // Product Details Section
                        Container(
                          height: 110 * SizeConfig.verticalBlock,
                          decoration: BoxDecoration(
                            color: Color(0x50E9E9E9),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(
                              width: 2 * SizeConfig.textRatio,
                              color: SizeConfig.iconColor,
                            ),
                          ),
                          width: 358 * SizeConfig.horizontalBlock,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0 * SizeConfig.textRatio),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      child: Image.network(
                                        products[index].imageURL, // Access productModel properties
                                        width: 100 * SizeConfig.horizontalBlock,
                                        height: 100 * SizeConfig.verticalBlock,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 150 * SizeConfig.horizontalBlock,
                                        child: Text(
                                          products[index].name, // Access productModel properties
                                          style: GoogleFonts.roboto(
                                            color: Color(0x90000000),
                                            fontSize: 20 * SizeConfig.textRatio,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        products[index].category?.isNotEmpty == true
                                            ? products[index].category!
                                            : "No Category", // Access productModel properties
                                        style: GoogleFonts.rubik(
                                          color: Color(0x50000000),
                                          fontSize: 11 * SizeConfig.textRatio,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "${products[index].price} E", // Access productModel properties
                                        style: GoogleFonts.roboto(
                                          color: Color(0xFF000000),
                                          fontSize: 20 * SizeConfig.textRatio,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20 * SizeConfig.verticalBlock),
                        Text(
                          "Offer",
                          style: GoogleFonts.roboto(fontSize: 20 * SizeConfig.textRatio),
                        ),
                        MyTextFormField(
                          controller: offer,
                          hintName: "EX: 50%",
                        ),
                        SizedBox(height: 20 * SizeConfig.verticalBlock),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "All Variations",
                                  style: GoogleFonts.roboto(fontSize: 20 * SizeConfig.textRatio),
                                ),
                                Text(
                                  "Quantity",
                                  style: GoogleFonts.roboto(fontSize: 20 * SizeConfig.textRatio),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 130 * SizeConfig.horizontalBlock,
                        height: 50 * SizeConfig.verticalBlock,
                        decoration: BoxDecoration(
                          color: Color(0x50E9E9E9),
                          border: Border.all(color: SizeConfig.iconColor, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (index > 0) {
                                index--; // Decrement index if it's greater than 0
                              }
                            });
                          },
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: null, // Disable IconButton's onPressed
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: SizeConfig.iconColor,
                                ),
                              ),
                              Text(
                                "Back",
                                style: GoogleFonts.rubik(color: SizeConfig.iconColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {

                            if (index < products.length - 1) {
                              index++; // Increment index if it's less than the last index
                            }else{
                              Navigator.pushNamed(context, BazarReview.id);
                            }
                          });
                        },
                        child: Container(
                          width: 130 * SizeConfig.horizontalBlock,
                          height: 50 * SizeConfig.verticalBlock,
                          decoration: BoxDecoration(
                            color: SizeConfig.iconColor,
                            border: Border.all(color: SizeConfig.iconColor, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                index == products.length -1 ? "Finish" : "Next", // Display current index + 1
                                style: GoogleFonts.rubik(color: Colors.white),
                              ),
                              IconButton(
                                onPressed: null, // Disable IconButton's onPressed
                                icon: Icon(
                                  Icons.arrow_forward_sharp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5 *SizeConfig.verticalBlock,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      products.length,
                          (currIndex) => Container(
                        height: 7 * SizeConfig.verticalBlock,
                        width:  7 * SizeConfig.horizontalBlock,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currIndex == index
                              ? SizeConfig.secondColor
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}