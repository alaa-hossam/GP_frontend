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
  List<dynamic> remainingVariations = [];
  Map<String, dynamic> selectedVariations = {}; // Track selected variations


  List<String> _getUniqueVariationTypes(List<dynamic> variations) {
    final uniqueTypes = <String>[];
    for (final variation in variations) {
      if (!uniqueTypes.contains(variation['variationType'])) {
        uniqueTypes.add(variation['variationType']);
      }
    }
    return uniqueTypes;
  }


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




  void onVariationSelected(String variationType, dynamic variationValue) {
    setState(() {
      selectedVariations[variationType] = variationValue;
    });
  }

  // Function to filter final products based on selected variations
  List<dynamic> getFilteredFinalProducts(productModel myProduct) {
    if (selectedVariations.isEmpty) {
      return myProduct.finalProducts ?? [];
    }

    return myProduct.finalProducts?.where((finalProduct) {
          return selectedVariations.entries.every((entry) {
            final variationType = entry.key;
            final selectedValue = entry.value;
            return finalProduct[variationType] == selectedValue;
          });
        }).toList() ??
        [];
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
                final filteredFinalProducts =
                    getFilteredFinalProducts(myProduct);

                return ListView(
                  children: [
                    // Product Image Section
                    Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 5.0 * SizeConfig.textRatio),
                          child: Stack(
                            children: [
                              Container(
                                height: 422 * SizeConfig.verticalBlock,
                                width: 361 * SizeConfig.horizontalBlock,
                                decoration: BoxDecoration(
                                  color: SizeConfig.iconColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
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
                                          color: exists
                                              ? Colors.red
                                              : SizeConfig.fontColor,
                                        ),
                                        onPressed: () {
                                          toggleFavourite(
                                            exists
                                                ? "red"
                                                : "${SizeConfig.fontColor}",
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
                          padding:
                              EdgeInsets.only(left: 5.0 * SizeConfig.textRatio),
                          child: Container(
                            width:
                                361 * SizeConfig.horizontalBlock, // Fixed width
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10 * SizeConfig.textRatio)),
                              color: Color(0X50E9E9E9),
                              border: Border.all(color: SizeConfig.iconColor),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.all(10.0 * SizeConfig.textRatio),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.person_outline),
                                          SizedBox(
                                              width: 5 *
                                                  SizeConfig.horizontalBlock),
                                          Text(
                                            '${myProduct.handcrafterName}',
                                            style: GoogleFonts.roboto(
                                              fontSize:
                                                  12 * SizeConfig.textRatio,
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
                                          SizedBox(
                                              width: 5 *
                                                  SizeConfig.horizontalBlock),
                                          Text("${myProduct.rate}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: 10 * SizeConfig.verticalBlock),
                                  Text(
                                    "${myProduct.name}",
                                    style: GoogleFonts.rubik(
                                      fontSize: 24 * SizeConfig.textRatio,
                                      color: Color(0X80000000),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                      height: 10 * SizeConfig.verticalBlock),
                                  Text(
                                    '${myProduct.description}',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14 * SizeConfig.textRatio,
                                      color: const Color(0X50000000),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                      height: 10 * SizeConfig.verticalBlock),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.chat,
                                        color: SizeConfig.iconColor,
                                      ),
                                      SizedBox(
                                          width: 5 * SizeConfig.verticalBlock),
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

                        if (myProduct.variations != null)
                          Column(

                            children: [
                              Container(
                                width: 361 * SizeConfig.horizontalBlock, // Fixed width
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10 * SizeConfig.textRatio),
                                  ),
                                  color: Color(0X50E9E9E9),
                                  border: Border.all(color: SizeConfig.iconColor),
                                ),
                                child:
                                Padding(
                                  padding:  EdgeInsets.all(15.0 * SizeConfig.verticalBlock),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Group variations by variationType
                                      for (final variationType in _getUniqueVariationTypes(myProduct.variations!))
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '$variationType',
                                              style: GoogleFonts.roboto(
                                                fontSize: 16 * SizeConfig.textRatio,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5 * SizeConfig.verticalBlock),
                                            // Display variation values horizontally
                                            SizedBox(
                                              height: 50, // Fixed height for the horizontal ListView
                                              child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                shrinkWrap: true,
                                                physics: ClampingScrollPhysics(),
                                                itemCount: myProduct.variations!
                                                    .where((v) => v['variationType'] == variationType)
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  final variation = myProduct.variations!
                                                      .where((v) => v['variationType'] == variationType)
                                                      .toList()[index];
                                                  final variationValue = variation['variationValue'];
                                                  return GestureDetector(
                                                    onTap: () {
                                                      onVariationSelected(
                                                        variation['variationType'],
                                                        variationValue,
                                                      );
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                        right: 8.0 * SizeConfig.horizontalBlock,
                                                      ),
                                                      padding: EdgeInsets.symmetric(
                                                        horizontal: 12 * SizeConfig.horizontalBlock,
                                                        vertical: 6 * SizeConfig.verticalBlock,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(10 * SizeConfig.textRatio),
                                                        ),
                                                        color: selectedVariations[variationType] ==
                                                            variationValue
                                                            ? Colors.blue // Highlight selected variation
                                                            : Color(0X50E9E9E9),
                                                        border: Border.all(
                                                          color: SizeConfig.iconColor,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '$variationValue',
                                                          style: GoogleFonts.rubik(
                                                            fontSize: 14 * SizeConfig.textRatio,
                                                            fontWeight: FontWeight.bold,
                                                            color: Color(0X80000000),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10 * SizeConfig.verticalBlock),
                            ],
                          ),


                        if (myProduct.finalProducts != null)
                          Column(
                            children: [
                              Container(
                                width: 361 *
                                    SizeConfig.horizontalBlock, // Fixed width
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10 * SizeConfig.textRatio),
                                  ),
                                  color: Color(0X50E9E9E9),
                                  border:
                                      Border.all(color: SizeConfig.iconColor),
                                ),
                                child: SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: myProduct.finalProducts?.length ??0,
                                    itemBuilder: (context, index) {

                                      return Padding(
                                        padding: EdgeInsets.all(
                                            8.0 * SizeConfig.horizontalBlock),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          child: SizedBox(
                                            width: 80 *
                                                SizeConfig
                                                    .horizontalBlock, // Constrain image width
                                            height: 80 *
                                                SizeConfig
                                                    .verticalBlock, // Constrain image height
                                            child: Image.network(
                                              myProduct.finalProducts?[index]['imageUrl'],
                                              fit: BoxFit
                                                  .cover, // Use BoxFit.cover to maintain aspect ratio
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 10 * SizeConfig.verticalBlock),
                            ],
                          )
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
