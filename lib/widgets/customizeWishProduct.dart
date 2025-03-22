import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/Providers/ProductProvider.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../views/productDetails.dart';

class customizeWishProuct extends StatefulWidget {
  final String imageURL, Name, Category, id;
  final double rate, Price;

  customizeWishProuct(this.imageURL, this.Name, this.Category, this.Price, this.rate, this.id);

  @override
  State<customizeWishProuct> createState() => _customizeWishProuctState();
}

class _customizeWishProuctState extends State<customizeWishProuct> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    // Use the provider instance from the widget tree
    final wishProvider = Provider.of<productProvider>(context, listen: false);

    return GestureDetector(
      child:
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15.0 * SizeConfig.horizontalBlock,
          vertical: 5 * SizeConfig.verticalBlock,
        ),
        child: Container(
          height: 110 * SizeConfig.verticalBlock,
          decoration: BoxDecoration(
            color: Color(0x50E9E9E9),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              width: 2 * SizeConfig.textRatio,
              color: SizeConfig.iconColor,
            ),
          ),
          width: 358 * SizeConfig.horizontalBlock,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0 * SizeConfig.textRatio),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: Image.network(
                        widget.imageURL,
                        width: 100 * SizeConfig.horizontalBlock,
                        height: 100 * SizeConfig.verticalBlock,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Add spacing
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
                    children: [
                      SizedBox(
                        width: 150 * SizeConfig.horizontalBlock, // Constrain the width
                        child: Text(
                          widget.Name,
                          style: GoogleFonts.roboto(
                            color: Color(0x90000000),
                            fontSize: 20 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(height: 5), // Add spacing
                      Text(
                        widget.Category,
                        style: GoogleFonts.rubik(
                          color: Color(0x50000000),
                          fontSize: 11 * SizeConfig.textRatio,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5), // Add spacing
                      Text(
                        "${widget.Price} E",
                        style: GoogleFonts.roboto(
                          color: Color(0xFF000000),
                          fontSize: 20 * SizeConfig.textRatio,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.favorite,
                        size: 30 * SizeConfig.textRatio,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        // Call deleteProduct from the provider
                        wishProvider.deleteProduct(widget.id);
                      },
                    ),
                    SizedBox(height: 10 * SizeConfig.verticalBlock), // Add spacing
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 20 * SizeConfig.textRatio,
                          color: const Color(0xFFD4931C),
                        ),
                        SizedBox(width: 5), // Add spacing
                        Text(
                          "${widget.rate}",
                          style: GoogleFonts.rubik(
                            color: Color(0x50000000),
                            fontSize: 11 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: (){
          Navigator.pushNamed(context,productDetails.id , arguments: widget.id);
      },
    );
  }
}