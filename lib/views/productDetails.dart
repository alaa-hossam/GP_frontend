import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:gp_frontend/Providers/ProductProvider.dart';
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

  toggleFavourite(String color, id) {
    wishListObj.isWishlistTableEmpty;
    setState(() {
      if (color == "${SizeConfig.fontColor}") {
        wishListObj.addProduct('''
            INSERT INTO WISHLIST(ID) 
            VALUES (
                "$id"
             
            )
''');
      } else {
        wishListObj.deleteProduct('''
      DELETE FROM wishList 
      WHERE ID = '$id'
      ''');
      }
    });
    // wishListObj.recreateWishListTable();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as String;
    productProvider productDetails = productProvider();

    return Scaffold(body:
        Consumer<productProvider>(builder: (context, productProvider, child) {
      return FutureBuilder(
          future: productDetails.getProductDetails(arguments),
          builder: (context, snapshot) {
            productModel myProduct = productDetails.productDetails;
            print("product details on screen");
            print(myProduct.imageURL);
            // final String? displayText = isExpanded
            //     ? myProduct.description
            //     : myProduct.description!.length > maxLength
            //         ? myProduct.description!.substring(0, maxLength) + '...'
            //         : myProduct.description;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 18.0 * SizeConfig.textRatio),
                    child: Stack(
                      children: [
                        Container(
                          height: 422 * SizeConfig.verticalBlock,
                          width: 361 * SizeConfig.horizontalBlock,
                          decoration: BoxDecoration(
                              color: SizeConfig.iconColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Center(
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
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
                              future: wishListObj.doesIdExist(
                                  myProduct.id), // Call the async function
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  // Handle errors
                                  return Icon(
                                    Icons.favorite,
                                    size: 22 * SizeConfig.textRatio,
                                    color: SizeConfig.fontColor,
                                  );
                                } else {
                                  // Use the result (true or false) to determine the color
                                  bool exists = snapshot.data ?? false;
                                  return CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        Icons.favorite,
                                        size: 25 * SizeConfig.textRatio,
                                        color: exists
                                            ? Colors.red
                                            : SizeConfig.fontColor,
                                      ),
                                      onPressed: () {
                                        toggleFavourite(
                                            exists
                                                ? "red"
                                                : "${SizeConfig.fontColor}",
                                            myProduct.id);
                                      },
                                    ),
                                  );
                                }
                              },
                            )),
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
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10 * SizeConfig.verticalBlock,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15.0 * SizeConfig.textRatio,
                        right: 15 * SizeConfig.textRatio),
                    child: Container(
                      width: 361 * SizeConfig.horizontalBlock,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(10 * SizeConfig.textRatio)),
                          color: Color(0X50E9E9E9),
                          border: Border.all(color: SizeConfig.iconColor)),
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
                                    SizedBox(
                                      width: 5 * SizeConfig.horizontalBlock,
                                    ),
                                    Text("handCrafter Name ",
                                        style: GoogleFonts.roboto(
                                            fontSize: 12 * SizeConfig.textRatio,
                                            color: Color(0x703C3C3C))),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Color(0xFFD4931C),
                                      size: 21 * SizeConfig.textRatio,
                                    ),
                                    SizedBox(
                                      width: 5 * SizeConfig.horizontalBlock,
                                    ),
                                    Text("${myProduct.rate}")
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10 * SizeConfig.verticalBlock,
                            ),
                            Text("${myProduct.name} ",
                                style: GoogleFonts.rubik(
                                    fontSize: 24 * SizeConfig.textRatio,
                                    color: Color(0X80000000),
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10 * SizeConfig.verticalBlock,
                            ),
                            Text(
                              '${myProduct.description}',
                              // displayText ?? "No Description",
                              style: GoogleFonts.roboto(
                                fontSize: 14 * SizeConfig.textRatio,
                                color: const Color(0X50000000),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // if (myProduct.description!.length > maxLength)
                            //   GestureDetector(
                            //     onTap: () {
                            //       setState(() {
                            //         isExpanded = !isExpanded;
                            //       });
                            //     },
                            //     child: Text(
                            //       isExpanded ? 'Read Less' : 'Read More',
                            //       style: GoogleFonts.roboto(
                            //         fontSize: 14 * SizeConfig.textRatio,
                            //         color: Colors.blue, // Customize the color
                            //         fontWeight: FontWeight.bold,
                            //       ),
                            //     ),
                            //   ),
                            SizedBox(
                              height: 10 * SizeConfig.verticalBlock,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.chat,
                                  color: SizeConfig.iconColor,
                                ),
                                SizedBox(
                                  width: 5 * SizeConfig.verticalBlock,
                                ),
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
                  SizedBox(height: 10 * SizeConfig.verticalBlock,),
                  if (myProduct.variations != null)
                    Padding(
                      padding: EdgeInsets.only(
                          left: 15.0 * SizeConfig.textRatio,
                          right: 15 * SizeConfig.textRatio),
                      child: ListView.builder(
                        shrinkWrap:
                        true, // To use inside another ListView
                        physics:
                        NeverScrollableScrollPhysics(), // Disable scrolling
                        itemCount: myProduct.variations?.length ?? 0,
                        itemBuilder: (context, index) {
                          final variation =
                          myProduct.variations?[index];
                          return Container(
                            width: 361 * SizeConfig.horizontalBlock,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(
                                        10 * SizeConfig.textRatio)),
                                color: Color(0X50E9E9E9),
                                border: Border.all(
                                    color: SizeConfig.iconColor)),
                            child: Padding(
                              padding:  EdgeInsets.all(8.0 * SizeConfig.horizontalBlock),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${variation['variationType']}',
                                        style: GoogleFonts.roboto(
                                          fontSize: 20 * SizeConfig.textRatio,
                                        ),
                                      ),
                                      SizedBox(width: 5 * SizeConfig.horizontalBlock,),
                                      Text(
                                        '${variation['sizeUnit']}',
                                        style: GoogleFonts.roboto(
                                          fontSize: 12 * SizeConfig.textRatio,
                                          color: SizeConfig.iconColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 15 * SizeConfig.horizontalBlock,),

                                  Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  10 * SizeConfig.textRatio)),
                                          color: Color(0X50E9E9E9),
                                          border: Border.all(
                                              color: SizeConfig.iconColor)),
                                      child: Padding(
                                        padding:  EdgeInsets.only(top: 8.0 * SizeConfig.textRatio, bottom: 8.0 * SizeConfig.textRatio
                                        ,left:16 * SizeConfig.textRatio  ,right: 16 * SizeConfig.textRatio),
                                        child: Text('${variation['variationValue']}',  style: GoogleFonts.rubik(
                                          fontSize: 24 * SizeConfig.textRatio,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                      ),
                                    ),
                                  )



                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  if (myProduct.finalProducts != null)
                    Padding(
                      padding: EdgeInsets.only(
                          left: 15.0 * SizeConfig.textRatio,
                          right: 15 * SizeConfig.textRatio),
                      child: ListView.builder(
                        shrinkWrap:
                        true, // To use inside another ListView
                        physics:
                        NeverScrollableScrollPhysics(), // Disable scrolling
                        itemCount: myProduct.finalProducts?.length ?? 0,
                        itemBuilder: (context, index) {
                          final variation =
                          myProduct.finalProducts?[index];
                          return Container(
                            width: 361 * SizeConfig.horizontalBlock,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(
                                        10 * SizeConfig.textRatio)),
                                color: Color(0X50E9E9E9),
                                border: Border.all(
                                    color: SizeConfig.iconColor)),
                            child: Padding(
                              padding:  EdgeInsets.all(8.0 * SizeConfig.horizontalBlock),
                              child:
                              ClipRRect(
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                                child: Image.network(
                                 myProduct.finalProducts?[index]?['imageUrl'],
                                width: 80 * SizeConfig.horizontalBlock,
                                  height: 80 * SizeConfig.verticalBlock,
                                  // fit: BoxFit.,
                                ),
                              ),
                            )
                            );
                        },
                      ),
                    ),
                ],
              );
            }
          });
    }));
  }
}
