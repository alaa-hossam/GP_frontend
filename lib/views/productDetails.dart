import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:gp_frontend/Providers/ProductProvider.dart';
import 'package:gp_frontend/views/productReviews.dart';
import 'package:gp_frontend/views/variationsDetails.dart';
import 'package:provider/provider.dart';

import '../SqfliteCodes/wishList.dart';
import '../widgets/Dimensions.dart';

class productDetails extends StatefulWidget {
  static String id = "productScreenDetails";
  const productDetails({super.key});

  @override
  State<productDetails> createState() => _productDetailsState();
}

class _productDetailsState extends State<productDetails> {
  wishList wishListObj = wishList();
  bool isExpanded = false;
  int maxLength = 50;


  void toggleFavourite(String color, String id) async {
    bool exists = await wishListObj.doesIdExist(id);
    setState(() {
      if (exists) {
        wishListObj.deleteProduct('''
          DELETE FROM wishList 
          WHERE ID = '$id'
        ''');
      } else {
        wishListObj.addProduct('''
          INSERT INTO WISHLIST(ID) 
          VALUES ('$id')
        ''');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as String;
    productProvider productDetails = productProvider();

    return Scaffold(
      body: Consumer<productProvider>(
        builder: (context, productProvider, child) {
          return FutureBuilder(
            future: productDetails.getProductDetails(arguments),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error loading product details"));
              } else {
                productModel myProduct = productDetails.productDetails;

                return ListView(
                  children: [
                    // Product Image Section
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5.0 * SizeConfig.textRatio),
                          child: Stack(
                            children: [
                              Container(
                                height: 422 * SizeConfig.verticalBlock,
                                width: 361 * SizeConfig.horizontalBlock,
                                decoration: BoxDecoration(
                                  color: SizeConfig.iconColor,
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    child: Image.network(
                                      myProduct.imageURL,
                                      width: 359 * SizeConfig.horizontalBlock,
                                      height: 420 * SizeConfig.verticalBlock,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 15,
                                right: 25,
                                child: FutureBuilder<bool>(
                                  future: wishListObj.doesIdExist(myProduct.id),
                                  builder: (context, snapshot) {
                                    bool exists = snapshot.data ?? false;
                                    return CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          Icons.favorite,
                                          size: 25 * SizeConfig.textRatio,
                                          color: exists ? Colors.red : SizeConfig.fontColor,
                                        ),
                                        onPressed: () {
                                          toggleFavourite(
                                            exists ? "red" : "${SizeConfig.fontColor}",
                                            myProduct.id,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                top: 15,
                                left: 15,
                                child: CircleAvatar(
                                  backgroundColor: const Color(0xFFD9D9D9),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.arrow_back_ios_new,
                                      size: 20 * SizeConfig.textRatio,
                                      color: const Color(0x503C3C3C),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10 * SizeConfig.verticalBlock),

                        // Product Details Section
                        Padding(
                          padding: EdgeInsets.only(left: 5.0 * SizeConfig.textRatio),
                          child: Container(
                            width: 361 * SizeConfig.horizontalBlock, // Fixed width
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10 * SizeConfig.textRatio)),
                              color: Color(0X50E9E9E9),
                              border: Border.all(color: SizeConfig.iconColor),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0 * SizeConfig.textRatio),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.person_outline),
                                          SizedBox(width: 5 * SizeConfig.horizontalBlock),
                                          Text(
                                            '${myProduct.handcrafterName}',
                                            style: GoogleFonts.roboto(
                                              fontSize: 12 * SizeConfig.textRatio,
                                              color: Color(0x703C3C3C),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Color(0xFFD4931C),
                                            size: 21 * SizeConfig.textRatio,
                                          ),
                                          SizedBox(width: 5 * SizeConfig.horizontalBlock),
                                          Text("${myProduct.rate}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10 * SizeConfig.verticalBlock),
                                  Text(
                                    "${myProduct.name}",
                                    style: GoogleFonts.rubik(
                                      fontSize: 24 * SizeConfig.textRatio,
                                      color: Color(0X80000000),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10 * SizeConfig.verticalBlock),
                                  Text(
                                    '${myProduct.description}',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14 * SizeConfig.textRatio,
                                      color: const Color(0X50000000),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10 * SizeConfig.verticalBlock),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, Productreviews.id);
                                        },
                                        icon:const Icon(
                                          Icons.chat,
                                          color: SizeConfig.iconColor,
                                        ),
                                      ),
                                      SizedBox(width: 5 * SizeConfig.verticalBlock),

                                      Text(
                                        '${myProduct.ratingCount} Reviews',
                                        style: GoogleFonts.roboto(
                                          fontSize: 14 * SizeConfig.textRatio,
                                          color: const Color(0X50000000),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10 * SizeConfig.verticalBlock),

                        SizedBox(height: 10 * SizeConfig.verticalBlock,),
                        // Text('${myProduct.finalProducts}'),
                        variationScreen(myProduct)
                      ],
                    ),
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }
}
