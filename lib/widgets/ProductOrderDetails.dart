import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';

class ProductOrderDetails extends StatelessWidget {
  final productModel product;

  ProductOrderDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    print(product.variations);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 55 * SizeConfig.verticalBlock,
          width: 55 * SizeConfig.horizontalBlock,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Padding(
            padding: EdgeInsets.all(5.0 * SizeConfig.verticalBlock),
            child: CircleAvatar(
              radius: 50 * SizeConfig.verticalBlock,
              backgroundColor: Colors.transparent,
              child: product.handcrafterImage == null
                  ? Image.asset("assets/images/logo.png")
                  : ClipOval(
                child: Image.network(
                  product.handcrafterImage!,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.person),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10 * SizeConfig.horizontalBlock),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.handcrafterName ?? "",
              style: GoogleFonts.roboto(
                fontSize: 16 * SizeConfig.textRatio,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: 300 * SizeConfig.horizontalBlock,
              height: 150 * SizeConfig.verticalBlock,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: SizeConfig.iconColor, width: 1),
                borderRadius: BorderRadius.circular(5 * SizeConfig.verticalBlock),
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
                      borderRadius: BorderRadius.circular(5 * SizeConfig.verticalBlock),
                    ),
                    child: product.imageURL == ""
                        ? Image.asset("assets/images/logo.png")
                        : Image.network(product.imageURL, fit: BoxFit.cover),
                  ),
                  SizedBox(width: 10 * SizeConfig.horizontalBlock),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name ?? "",
                          style: GoogleFonts.roboto(
                            fontSize: 16 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5 * SizeConfig.verticalBlock),
                        if (product.variations != null)
                          Expanded(
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: product.variations!.length,
                              itemBuilder: (context, index) {
                                final variation = product.variations![index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2 * SizeConfig.verticalBlock),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${variation['variationType']}: ",
                                        style: GoogleFonts.roboto(
                                          fontSize: 16 * SizeConfig.textRatio,
                                          color: Color(0x50000000),
                                        ),
                                      ),Text(
                                        variation['variationValue'],
                                        style: GoogleFonts.roboto(
                                          fontSize: 16 * SizeConfig.textRatio,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        Row(
                          children: [
                            Text(
                              "Quantity: ",
                              style: GoogleFonts.roboto(
                                fontSize: 16 * SizeConfig.textRatio,
                                color: Color(0x50000000),
                              ),
                            ),

                            Text(
                              "${product.Quantity}",
                              style: GoogleFonts.roboto(
                                fontSize: 16 * SizeConfig.textRatio,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Price: ",
                              style: GoogleFonts.roboto(
                                fontSize: 16 * SizeConfig.textRatio,
                                color: Color(0x50000000),
                              ),
                            ),

                            Text(
                              "${product.price}",
                              style: GoogleFonts.roboto(
                                fontSize: 16 * SizeConfig.textRatio,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
