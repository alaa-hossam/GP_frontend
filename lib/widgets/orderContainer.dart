import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:intl/intl.dart';

import '../views/OrderDetails.dart';

class OrderContainer extends StatelessWidget {
  final Map<String, dynamic> order;
  OrderContainer({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    print(order['products']);
    String shortId = order['id'].toString().split('-').first;
    DateTime parsedDate = DateTime.parse(order['date']);
    String formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          OrderDetailsScreen.id,
          arguments: {'order': order}

        );
      },
      child: Column(
        children: [
          Container(
            width: 358 * SizeConfig.horizontalBlock,
            height: 150 * SizeConfig.verticalBlock,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: SizeConfig.iconColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(5 * SizeConfig.verticalBlock)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(width: 3 * SizeConfig.horizontalBlock),
                Container(
                  height: 140 * SizeConfig.verticalBlock,
                  width: 140 * SizeConfig.horizontalBlock,
                  decoration: BoxDecoration(
                    border: Border.all(color: SizeConfig.iconColor, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(5 * SizeConfig.verticalBlock)),
                  ),
                  child: Image.asset("assets/images/logo.png"),
                ),
                SizedBox(width: 3 * SizeConfig.horizontalBlock,),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5 * SizeConfig.verticalBlock),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 205 * SizeConfig.horizontalBlock,
                        child: Row(
                          children: [
                            Text(
                              "Order #",
                              style: GoogleFonts.roboto(
                                fontSize: 16 * SizeConfig.textRatio,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              shortId,
                              style: GoogleFonts.roboto(
                                fontSize: 16 * SizeConfig.textRatio,
                              ),
                            ),
                            SizedBox(width: 20 * SizeConfig.horizontalBlock,),
                            Text(
                              "${order['quantity']} items",
                              style: GoogleFonts.roboto(
                                fontSize: 16 * SizeConfig.textRatio,
                              ),
                            ),

                          ],

                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 170 * SizeConfig.horizontalBlock,
                            child: Text(
                              "Totlal Price   ${order['orderPrice']} LE",
                              style: GoogleFonts.roboto(
                                fontSize: 16 * SizeConfig.textRatio,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                        ],

                      ),

                      Text(
                        "${formattedDate}",
                        style: GoogleFonts.roboto(
                          fontSize: 16 * SizeConfig.textRatio,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10 * SizeConfig.verticalBlock),
        ],
      ),
    );
  }
}
