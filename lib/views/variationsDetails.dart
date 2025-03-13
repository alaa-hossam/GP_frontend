import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Providers/detailsProvider.dart';
import 'package:provider/provider.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';

class variationScreen extends StatefulWidget {
  final List<dynamic>? variations, finalProducts;

  variationScreen(this.variations, this.finalProducts);

  @override
  State<variationScreen> createState() => _variationScreenState();
}

class _variationScreenState extends State<variationScreen> {
  final variationMap = <String, List<String>>{};
  bool showCartIcon = false;
  static int count = 0;

  @override
  void initState() {
    super.initState();
    _getVariationMap();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final detailsProductProvider =
          Provider.of<detailsProvider>(context, listen: false);
      detailsProductProvider.initializeFinalProducts(widget.finalProducts!);
    });
  }

  Map<String, List<String>> _getVariationMap() {
    if (widget.variations != null) {
      for (final variation in widget.variations!) {
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
                                    // Toggle selection logic
                                    if (detailsProvider
                                            .selectedVariations[key] ==
                                        value) {
                                      detailsProvider.deselectVariation(key);
                                      detailsProvider.updateFinalProduct(
                                          widget.finalProducts!);
                                      detailsProvider.getPrice();
                                    } else {
                                      detailsProvider.selectVariation(
                                          key, value);
                                      detailsProvider.updateFinalProduct(
                                          widget.finalProducts!);
                                      detailsProvider.getPrice();
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
                      // Row for "Add To Cart" button and cart icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (!showCartIcon) {
                                  showCartIcon = !showCartIcon;
                                }
                                if (detailsProvider.finalPrice != 0) {
                                  count += detailsProvider
                                      .finalProductsProvider.length;
                                }
                              });
                            },
                            child: Container(
                              width: 320 * SizeConfig.verticalBlock,
                              height: 50 * SizeConfig.horizontalBlock,
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
                          SizedBox(
                              width:
                                  10 * SizeConfig.horizontalBlock), // Spacing
                          if (showCartIcon) // Show cart icon conditionally
                            Stack(children: [
                              Icon(
                                Icons.shopping_cart,
                                size: 40 * SizeConfig.textRatio,
                                color: SizeConfig.iconColor,
                              ),
                              Positioned(
                                bottom:3* SizeConfig.verticalBlock,
                                  right: 2 * SizeConfig.horizontalBlock,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.white,
                                    child: Text("${count}"),)
                              )
                            ]
                            
                            ),
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
