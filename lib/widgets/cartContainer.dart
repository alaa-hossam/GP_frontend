import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/ProductModel.dart';

import 'Dimensions.dart';

class CartItem extends StatelessWidget {
  final productModel product;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const CartItem({
    Key? key,
    required this.product,
    required this.onIncrease,
    required this.onDecrease,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 5 * SizeConfig.verticalBlock,
        left: 5 * SizeConfig.horizontalBlock,
        right: 5 * SizeConfig.horizontalBlock,
      ),
      child: Container(
        width: 358 * SizeConfig.horizontalBlock,
        height: 150 * SizeConfig.verticalBlock,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0x50E9E9E9),
          border: Border.all(width: 2, color: SizeConfig.iconColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: Image.network(
                product.imageURL,
                width: 140 * SizeConfig.horizontalBlock,
                height: 140 * SizeConfig.verticalBlock,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 100 * SizeConfig.horizontalBlock,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10 * SizeConfig.verticalBlock,
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: GoogleFonts.roboto(
                            fontSize: 16 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          product.category!,
                          style: GoogleFonts.rubik(
                            fontSize: 11 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold,
                            color: Color(0x50000000),
                          ),
                        ),
                        if (product.variations != null && product.variations!.isNotEmpty)
                          ...product.variations!.map((variation) {
                            final variationType = variation['productVariation']?['variationType'] ?? 'N/A';
                            final variationValue = variation['productVariation']?['variationValue'] ?? 'N/A';
                            return Text(
                              '$variationType: $variationValue',
                              style: GoogleFonts.roboto(
                                color: Color(0x50000000),
                                fontSize: 12 * SizeConfig.textRatio,
                              ),
                            );
                          }).toList(),
                        SizedBox(height: 10 * SizeConfig.verticalBlock),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      child: Text(
                        '${product.price * product.Quantity!} EG',
                        style: GoogleFonts.roboto(
                          fontSize: 20 * SizeConfig.textRatio,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Color(0xFFD4931C)),
                    Text(
                      '${product.rate}',
                      style: GoogleFonts.rubik(
                        color: Color(0x50000000),
                        fontSize: 11 * SizeConfig.textRatio,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 10 * SizeConfig.verticalBlock,
                    top: 10 * SizeConfig.verticalBlock,
                    bottom: 3 * SizeConfig.verticalBlock,
                    right: 5 * SizeConfig.horizontalBlock,
                  ),
                  child: Container(
                    width: 110 * SizeConfig.horizontalBlock,
                    height: 42 * SizeConfig.verticalBlock,
                    decoration: BoxDecoration(
                      border: Border.all(color: SizeConfig.iconColor),
                      borderRadius: BorderRadius.all(Radius.circular(10 * SizeConfig.textRatio)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: onDecrease,
                          icon: Icon(Icons.minimize_outlined, size: 20 * SizeConfig.textRatio),
                        ),
                        Text("${product.Quantity}", style: GoogleFonts.roboto(fontSize: 16 * SizeConfig.textRatio)),
                        IconButton(
                          onPressed: onIncrease,
                          icon: Icon(Icons.add, size: 20 * SizeConfig.textRatio),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}