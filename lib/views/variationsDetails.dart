import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:gp_frontend/Providers/detailsProvider.dart';
import 'package:gp_frontend/views/cartView.dart';
import 'package:provider/provider.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import '../SqfliteCodes/cart.dart';
class variationScreen extends StatefulWidget {
  productModel myProduct;

  variationScreen(this.myProduct);

  @override
  State<variationScreen> createState() => _variationScreenState();
}

class _variationScreenState extends State<variationScreen> {
  final variationMap = <String, List<String>>{};
  // bool showCartIcon = false;
  static int count = 0;

  @override
  void initState() {
    super.initState();
    _getVariationMap();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final detailsProductProvider =
      Provider.of<detailsProvider>(context, listen: false);
      detailsProductProvider.initializeFinalProducts(widget.myProduct.finalProducts!);
    });
    count = 0;
  }

  Map<String, List<String>> _getVariationMap() {
    if (widget.myProduct.variations != null) {
      for (final variation in widget.myProduct.variations!) {
        final variationType = variation['variationType'];
        final variationValue = variation['variationValue'];

        if (variationMap.containsKey(variationType)) {
          variationMap[variationType]!.add(variationValue);
        } else {
          variationMap[variationType] = [variationValue];
        }
      }
    }
    return variationMap;
  }

  void insertProductData(String id, String finalId) async {
    Cart myCart = Cart();

    print("insert product in cart");
    await myCart.addProduct(id, finalId);
    print('Product data inserted!');
  }

  void _showGalleryPopup(BuildContext context, List<dynamic> galleryImages) {
    final galleryProvider = Provider.of<galleryImageProvider>(context, listen: false);
    galleryProvider.setGalleryImages(galleryImages);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: double.maxFinite,
            height: 350, // Adjust height as needed
            child: Column(
              children: [
                Expanded(
                  child: Consumer<galleryImageProvider>(
                    builder: (context, galleryProvider, child) {
                      return PageView.builder(
                        controller: galleryProvider.pageController,
                        itemCount: galleryProvider.galleryImages.length,
                        onPageChanged: (index) {
                          galleryProvider.updateCurrentIndex(index);
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                galleryProvider.galleryImages[index]['imageUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                // Dots (indicators) for the current image
                Consumer<galleryImageProvider>(
                  builder: (context, galleryProvider, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        galleryProvider.galleryImages.length,
                            (index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: galleryProvider.currentIndex == index
                                  ? SizeConfig.iconColor // Highlighted dot
                                  : Colors.grey, // Unhighlighted dot
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the pop-up
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: SizeConfig.iconColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<detailsProvider>(
      builder: (context, detailsProvider, child) {
        return Stack(
          children: [
            Column(
              children: [
                ...variationMap.keys.map((key) {
                  return Container(
                    width: 361 * SizeConfig.horizontalBlock,
                    margin: EdgeInsets.symmetric(
                        vertical: 10 * SizeConfig.verticalBlock),
                    padding: EdgeInsets.all(10 * SizeConfig.verticalBlock),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(10 * SizeConfig.textRatio)),
                      color: Color(0X50E9E9E9),
                      border: Border.all(color: SizeConfig.iconColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          key,
                          style: GoogleFonts.roboto(
                            fontSize: 20 * SizeConfig.textRatio,
                            color: Color(0X80000000),
                          ),
                        ),
                        SizedBox(height: 10 * SizeConfig.verticalBlock),
                        SizedBox(
                            height: 50 * SizeConfig.verticalBlock,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: variationMap[key]?.length ?? 0,
                              itemBuilder: (context, valueIndex) {
                                final value = variationMap[key]![valueIndex];

                                return GestureDetector(
                                  onTap: () {

                                    if (detailsProvider
                                        .selectedVariations[key] ==
                                        value) {
                                      setState(() {
                                        count =0;

                                      });
                                      detailsProvider.deselectVariation(key, widget.myProduct.finalProducts!);
                                    } else {
                                      setState(() {
                                        count =0;

                                      });

                                      detailsProvider.selectVariation(
                                          key, value, widget.myProduct.finalProducts!);
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        right:
                                        8.0 * SizeConfig.horizontalBlock),
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                      12 * SizeConfig.horizontalBlock,
                                      vertical: 6 * SizeConfig.verticalBlock,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            10 * SizeConfig.textRatio),
                                      ),
                                      color: Color(0X50E9E9E9),
                                      border: Border.all(
                                        width: detailsProvider
                                            .selectedVariations[key] ==
                                            value
                                            ? 4
                                            : 1,
                                        color: SizeConfig.iconColor,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        value,
                                        style: GoogleFonts.rubik(
                                          fontSize: 20 * SizeConfig.textRatio,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )),
                      ],
                    ),
                  );
                }).toList(),
                Container(
                  width: 361 * SizeConfig.horizontalBlock,
                  margin: EdgeInsets.symmetric(
                      vertical: 10 * SizeConfig.verticalBlock),
                  padding: EdgeInsets.all(10 * SizeConfig.verticalBlock),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(10 * SizeConfig.textRatio)),
                    color: Color(0X50E9E9E9),
                    border: Border.all(color: SizeConfig.iconColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Price:",
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        "${detailsProvider.finalPrice} EGP",
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      )
                    ],
                  ),
                ),
                if (detailsProvider.finalProductsProvider.isNotEmpty)
                  Column(
                    children: [
                      Container(
                        width: 361 * SizeConfig.horizontalBlock,
                        margin: EdgeInsets.symmetric(
                            vertical: 10 * SizeConfig.verticalBlock),
                        padding: EdgeInsets.all(10 * SizeConfig.verticalBlock),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(10 * SizeConfig.textRatio)),
                          color: Color(0X50E9E9E9),
                          border: Border.all(color: SizeConfig.iconColor),
                        ),
                        child: SizedBox(
                          height: 80 * SizeConfig.verticalBlock,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount:
                              detailsProvider.finalProductsProvider.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Show the gallery pop-up when the image is clicked
                                        _showGalleryPopup(
                                          context,
                                          detailsProvider
                                              .finalProductsProvider[index]
                                          ['galleryImages'],
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        child: Image.network(
                                          detailsProvider
                                              .finalProductsProvider[index]
                                          ['imageUrl'],
                                          width:
                                          80 * SizeConfig.horizontalBlock,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        width: 10 * SizeConfig.horizontalBlock)
                                  ],
                                );
                              }),
                        ),
                      ),
                      // Row for "Add To Cart" button and Plus icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if( detailsProvider.finalProductsProvider.length == 1)
                            Container(
                              width: 120 * SizeConfig.horizontalBlock,
                              height: 55 * SizeConfig.verticalBlock,
                              decoration:BoxDecoration(
                                  border: Border.all(color: SizeConfig.iconColor),
                                  borderRadius: BorderRadius.all(Radius.circular(10 * SizeConfig.textRatio))
                              ),
                              child: Row(

                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(bottom: 20 * SizeConfig.verticalBlock),
                                    child: IconButton(onPressed: (){setState(() {
                                      if(count > 0) {
                                        count--;

                                      }
                                    });}, icon: Icon(Icons.minimize_outlined , size: 24 * SizeConfig.textRatio,)),
                                  ),

                                  Text("${count}", style: GoogleFonts.roboto(fontSize: 20 * SizeConfig.textRatio), ),
                                  IconButton(onPressed: (){setState(() {
                                    if(detailsProvider.finalPrice == 0){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "You Should specify product First")));
                                    }else{
                                      count++;

                                    }
                                  });}, icon: Icon(Icons.add , size: 24 * SizeConfig.textRatio,) ,),

                                ],
                              ),
                            ),
                          SizedBox(
                              width:
                              10 * SizeConfig.horizontalBlock),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                // if (!showCartIcon) {
                                //   showCartIcon = !showCartIcon;
                                // }
                                // if (detailsProvider.finalPrice != 0) {
                                //   count++;
                                // }
                              });
                              if (detailsProvider.finalPrice == 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "You Should specify product First")));
                              } else if (detailsProvider
                                  .finalProductsProvider.length >
                                  1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "You Should specify one product")));
                              } else {
                                for(int  i = 0 ; i < count ; i++){
                                  insertProductData(widget.myProduct.id,
                                      detailsProvider.selectedFinalProductId!);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "products added successfully")));

                              }
                            },
                            child: Container(
                              width: 240 * SizeConfig.verticalBlock,
                              height: 55 * SizeConfig.horizontalBlock,
                              decoration: BoxDecoration(
                                color: SizeConfig.iconColor,
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Center(
                                child: Text(
                                  "Add To Cart",
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 20 * SizeConfig.textRatio,
                                  ),
                                ),
                              ),
                            ),
                          ),


                          // Spacing
                          // if (showCartIcon) // Show cart icon conditionally
                          //   Stack(children: [
                          //     IconButton(
                          //         icon: Icon(
                          //           Icons.shopping_cart,
                          //           size: 40 * SizeConfig.textRatio,
                          //           color: SizeConfig.iconColor,
                          //         ),
                          //         onPressed: () {
                          //           Navigator.pushNamed(context, cartScreen.id,
                          //               arguments: widget.myProduct.id);
                          //         }),
                          //     Positioned(
                          //         bottom: 3 * SizeConfig.verticalBlock,
                          //         right: 2 * SizeConfig.horizontalBlock,
                          //         child: CircleAvatar(
                          //           radius: 10,
                          //           backgroundColor: Colors.white,
                          //           child: Text("${count}"),
                          //         ))
                          //   ]),
                        ],
                      ),
                      SizedBox(
                        height: 10 * SizeConfig.verticalBlock,
                      ),
                    ],
                  ),
                if (detailsProvider.finalProductsProvider.isEmpty)
                  Column(
                    children: [
                      SizedBox(
                        height: 10 * SizeConfig.verticalBlock,
                      ),
                      Text(
                        "No Product Available",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0x80000000)),
                      ),
                      SizedBox(
                        height: 10 * SizeConfig.verticalBlock,
                      ),
                    ],
                  )
              ],
            ),
          ],
        );
      },
    );
  }
}