import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:gp_frontend/views/productDetails.dart';

import 'Dimensions.dart';

class compareColumn extends StatelessWidget {
  String id, imageUrl, name;
  double price, rate;
  String? category, description;
  double? stock;

  compareColumn(
      this.id, this.imageUrl, this.name, this.price, this.rate , {this.category , this.description, this.stock});

  @override
  Widget build(BuildContext context) {
    productModel product =
        productModel(id, imageUrl, name,category:  category, price, rate , description: this.description , stock: this.stock);

    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 165 * SizeConfig.verticalBlock,
              width: 159 * SizeConfig.horizontalBlock,
              decoration: BoxDecoration(
                  color: SizeConfig.iconColor,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Image.network(
                    product.imageURL,
                    width: 155 * SizeConfig.horizontalBlock,
                    height: 161 * SizeConfig.verticalBlock,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 150 * SizeConfig.horizontalBlock,
              child: Center(
                child: Text(
                  product.name,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0x80000000)),
                ),
              ),
            ),
            SizedBox(
              height: 20 * SizeConfig.verticalBlock,
            ),
            Container(
              // width: 149 * SizeConfig.horizontalBlock,
              // height: 26 * SizeConfig.verticalBlock,
              decoration: BoxDecoration(
                  color: Color(0x50E9E9E9),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Category: ",
                        style: GoogleFonts.roboto(
                            fontSize: 16 * SizeConfig.textRatio,
                            color: Color(0x503C3C3C))),
                    Text("${product.category}",
                        style:
                            GoogleFonts.roboto(fontSize: 16 * SizeConfig.textRatio))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10 * SizeConfig.verticalBlock,
            ),
            Container(
              // width: 149 * SizeConfig.horizontalBlock,
              // height: 26 * SizeConfig.verticalBlock,
              decoration: BoxDecoration(
                  color: Color(0x50E9E9E9),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Description: ",
                        style: GoogleFonts.roboto(
                            fontSize: 16 * SizeConfig.textRatio,
                            color: Color(0x503C3C3C))),
                    Text("${product.description}",
                        style:
                            GoogleFonts.roboto(fontSize: 16 * SizeConfig.textRatio))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10 * SizeConfig.verticalBlock,
            ),
            Container(
              // width: 149 * SizeConfig.horizontalBlock,
              // height: 26 * SizeConfig.verticalBlock,
              decoration: BoxDecoration(
                  color: Color(0x50E9E9E9),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Number of pieces: ",
                        style: GoogleFonts.roboto(
                            fontSize: 16 * SizeConfig.textRatio,
                            color: Color(0x503C3C3C))),
                    Text("${product.stock}",
                        style:
                            GoogleFonts.roboto(fontSize: 16 * SizeConfig.textRatio))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10 * SizeConfig.verticalBlock,
            ),
            Container(
              // width: 149 * SizeConfig.horizontalBlock,
              // height: 26 * SizeConfig.verticalBlock,
              decoration: const BoxDecoration(
                  color: Color(0x50E9E9E9),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Rate: ",
                        style: GoogleFonts.roboto(
                            fontSize: 16 * SizeConfig.textRatio,
                            color: Color(0x503C3C3C))),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(Icons.star,
                          color: index < product.rate ? Colors.amber : Colors.grey, // Colored if index < rate
                          size: 20 * SizeConfig.textRatio,
                        );
                      }),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10 * SizeConfig.verticalBlock,
            ),
            Container(
              // width: 149 * SizeConfig.horizontalBlock,
              // height: 26 * SizeConfig.verticalBlock,
              decoration:const BoxDecoration(
                  color: Color(0x50E9E9E9),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Price: ",
                        style: GoogleFonts.roboto(
                            fontSize: 16 * SizeConfig.textRatio,
                            color: Color(0x503C3C3C))),
                    Text("${product.price}",
                        style:
                            GoogleFonts.roboto(fontSize: 16 * SizeConfig.textRatio))
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 2 * SizeConfig.verticalBlock,
          left: 17 * SizeConfig.horizontalBlock,
          child: GestureDetector(
            child: Container(
              width: 174 * SizeConfig.verticalBlock,
              height: 50 * SizeConfig.horizontalBlock,
              decoration: BoxDecoration(
                color: SizeConfig.iconColor,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Center(
                child: Text(
                  "show Details ",
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 20 * SizeConfig.textRatio,
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context,productDetails.id , arguments: product.id);
            },
          ),
        )
      ],
    );
  }
}
