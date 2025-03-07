import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/Providers/ProductProvider.dart';
import 'package:gp_frontend/SqfliteCodes/wishList.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class customizeWishProuct extends StatefulWidget {
  String imageURL, Name, Category, id;
  double Price, rate ;

  customizeWishProuct(this.imageURL, this.Name, this.Category, this.Price, this.rate, this.id);
  State<customizeWishProuct> createState() => _customizeWishProuctState(
      this.imageURL, this.Name, this.Category, this.Price, this.rate , this.id);

}

class _customizeWishProuctState extends State<customizeWishProuct> {
  bool isFav = false;
  String imageURL, Name, Category, id;
  double Price, rate;

  _customizeWishProuctState(
      this.imageURL, this.Name, this.Category, this.Price, this.rate, this.id);

  @override
  Widget build(BuildContext context) {
    // Use the provider instance from the widget tree
    final wishProvider = Provider.of<productProvider>(context, listen: false);

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 15.0 * SizeConfig.horizontalBlock,
          vertical: 5 * SizeConfig.verticalBlock),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0x50E9E9E9),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(
              width: 2 * SizeConfig.textRatio, color: SizeConfig.iconColor),
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
                      imageURL,
                      width: 100 * SizeConfig.horizontalBlock,
                      height: 100 * SizeConfig.verticalBlock,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$Name",
                            style: GoogleFonts.roboto(
                                color: Color(0x90000000),
                                fontSize: 20 * SizeConfig.textRatio,
                                fontWeight: FontWeight.bold)),
                        Text("$Category",
                            style: GoogleFonts.rubik(
                                color: Color(0x50000000),
                                fontSize: 11 * SizeConfig.textRatio,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text("$Price " + "E",
                        style: GoogleFonts.roboto(
                            color: Color(0xFF000000),
                            fontSize: 20 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
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
                      wishProvider.deleteProduct(id);
                    },
                  ),
                  SizedBox(height: 20 * SizeConfig.verticalBlock),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 20 * SizeConfig.textRatio,
                        color: const Color(0xFFD4931C),
                      ),
                      Text("$rate",
                          style: GoogleFonts.rubik(
                              color: Color(0x50000000),
                              fontSize: 11 * SizeConfig.textRatio,
                              fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}