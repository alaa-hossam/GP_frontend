import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/ProductModel.dart';
import 'Dimensions.dart';

class BazarProduct extends StatelessWidget {
  final productModel product;
  final VoidCallback onAddProduct;

  const BazarProduct({
    Key? key,
    required this.product,
    required this.onAddProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Tapped on ${product.name}");
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10 * SizeConfig.textRatio),
          color: const Color(0x50E9E9E9),
          border: Border.all(width: 1.5, color: SizeConfig.iconColor),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    product.imageURL,
                    width: double.infinity,
                    height: 150 * SizeConfig.verticalBlock,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.black.withOpacity(0.2),
                        child: Center(
                          child: Icon(Icons.broken_image, color: Colors.white, size: 150 * SizeConfig.verticalBlock),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Color(0xFFD4931C), size: 14),
                          SizedBox(width: 3),
                          Text(
                            '${product.rate}',
                            style: GoogleFonts.rubik(
                              fontSize: 11,
                              color: Color(0x50000000),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        product.category ?? '',
                        style: GoogleFonts.rubik(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0x50000000),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 4,
              bottom: 4,
              child: Row(
                children: [
                  Text(
                    "${product.price} LE" ?? '0',
                    style: GoogleFonts.rubik(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width:  70 * SizeConfig.horizontalBlock,),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.green),
                    onPressed: onAddProduct,
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
