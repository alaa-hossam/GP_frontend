import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Dimensions.dart';

class PriceSummary extends StatelessWidget {
  final double totalPrice;
  final int discountPercentage;
  final String type;

  const PriceSummary({
    Key? key,
    required this.totalPrice,
    required this.type,
    required this.discountPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double discountedPrice;

    if (type.toLowerCase() == "amount") {
      discountedPrice = totalPrice - discountPercentage;
    } else {
      discountedPrice = totalPrice - (totalPrice * (discountPercentage / 100));
    }
    return Column(
      children: [
        if (discountPercentage != 0)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 50 * SizeConfig.horizontalBlock),
                    child: Text("Price",
                        style: GoogleFonts.rubik(
                            fontSize: 24 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold,
                            color: Color(0x70000000))),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(right: 30 * SizeConfig.horizontalBlock),
                    child: Text("LE $discountedPrice",
                        style: GoogleFonts.rubik(
                            fontSize: 24 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold,
                            color: Color(0x70000000))),
                  ),
                ],
              ),
              SizedBox(height: 10 * SizeConfig.verticalBlock),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 50 * SizeConfig.horizontalBlock),
                    child: Text("Discount",
                        style: GoogleFonts.rubik(
                            fontSize: 24 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold,
                            color: Color(0x70000000))),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(right: 30 * SizeConfig.horizontalBlock),
                    child: Text(type.toLowerCase()=="amount" ?
                    "$discountPercentage LE"
                        :"$discountPercentage %" ,
                        style: GoogleFonts.rubik(
                            fontSize: 24 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold,
                            color: Color(0x70000000))),
                  ),
                ],
              ),
              SizedBox(height: 10 * SizeConfig.verticalBlock),
              Container(
                width: 232 * SizeConfig.horizontalBlock,
                height: 2 * SizeConfig.verticalBlock,
                color: Colors.grey,
              ),
            ],
          ),
        SizedBox(height: 20 * SizeConfig.verticalBlock),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Total Price",
                style: GoogleFonts.rubik(
                    fontSize: 24 * SizeConfig.textRatio,
                    fontWeight: FontWeight.bold)),
            Text('$totalPrice',
                style: GoogleFonts.rubik(
                    fontSize: 24 * SizeConfig.textRatio,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
