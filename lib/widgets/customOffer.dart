import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/offerModel.dart';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:gp_frontend/widgets/customizeButton.dart';

import 'Dimensions.dart';

class customOffer extends StatelessWidget {
  offerModel offer;
  String clientId;
  bool match = false;
  customOffer({super.key, required this.offer, required this.clientId });
  String? _getValidImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return null;

    try {
      final uri = Uri.parse(imageUrl);
      if (uri.hasAbsolutePath && !imageUrl.contains('http', 10)) {
        return imageUrl;
      } else {
        print("Invalid image URL detected: $imageUrl");
        return null;
      }
    } catch (e) {
      print("Failed to parse image URL: $imageUrl");
      return null;
    }
  }


  Future<bool> checkId()async{
    Token token = Token();
    final idSQL = await token.getUUID('SELECT UUID FROM TOKENS');
    if (idSQL == clientId) {
      match = true;
    } else {
      match = false;
    }
    return true;
  }
  String _getTimeAgo(DateTime createdAt) {
    DateTime now = DateTime.now().toUtc();
    Duration difference = now.difference(createdAt);

    if (difference.inHours > 8640) {
      int years = (difference.inHours / 8760).toInt();
      return "$years yrs";
    } else if (difference.inHours > 720) {
      int months = (difference.inHours / 720).toInt();
      return "$months mos";
    } else if (difference.inHours > 24) {
      int days = (difference.inHours / 24).toInt();
      return "$days days";
    } else {
      return "${difference.inHours} hrs";
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime createdAt;
    try {
      createdAt = DateTime.parse(offer.createdAt ?? "");
    } catch (e) {
      createdAt = DateTime.now();
    }
    final String? validProfileImageUrl = _getValidImageUrl(offer.profileImage);
    final String timeAgo = _getTimeAgo(createdAt);

    return Column(
      children: [
        Row(
          children: [
            if (validProfileImageUrl != null)
              Padding(
                padding: EdgeInsets.all(5.0 * SizeConfig.horizontalBlock),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(validProfileImageUrl),
                  backgroundColor: Colors.transparent,
                  radius: 20 * SizeConfig.horizontalBlock,
                ),
              )
            else
              Padding(
                padding: EdgeInsets.all(5.0 * SizeConfig.horizontalBlock),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 20 * SizeConfig.horizontalBlock,
                  child: Icon(
                    Icons.person,
                    color: Colors.grey[600],
                    size: 20 * SizeConfig.textRatio,
                  ),
                ),
              ),
            SizedBox(width: 10 * SizeConfig.horizontalBlock),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${offer.name}",
                  style: GoogleFonts.roboto(
                      fontSize: 10 * SizeConfig.textRatio,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  timeAgo,
                  style: GoogleFonts.roboto(
                      fontSize: 8 * SizeConfig.textRatio,
                      color: const Color(0x503C3C3C)),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10 * SizeConfig.verticalBlock,),

        Container(
          color: Color(0x50E9E9E9),
          child: Padding(
            padding:  EdgeInsets.all(10.0 * SizeConfig.horizontalBlock),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${offer.description}",
                  style:
                      GoogleFonts.roboto(fontSize: 14 * SizeConfig.textRatio, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20 * SizeConfig.verticalBlock,),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Price: ",
                              style: GoogleFonts.roboto(
                                  fontSize: 12 * SizeConfig.textRatio,
                                  color: Color(0x50000000),fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${offer.price} LE",
                              style: GoogleFonts.roboto(
                                  fontSize: 12 * SizeConfig.textRatio, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Duration: ",
                              style: GoogleFonts.roboto(
                                  fontSize: 12 * SizeConfig.textRatio,
                                  color: Color(0x50000000),fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${offer.duration} days",
                              style: GoogleFonts.roboto(
                                  fontSize: 12 * SizeConfig.textRatio,fontWeight: FontWeight.bold),
                            ),

                          ],
                        )
                      ],
                    ),

                      FutureBuilder<bool>(
                        future: checkId(),
                        builder: (context , child) {
                          if(match){
                            return customizeButton(
                              buttonName: "Confirm",
                              buttonColor: SizeConfig.iconColor,
                              fontColor: Colors.white,
                              height: 30 * SizeConfig.verticalBlock,
                              width: 90 * SizeConfig.horizontalBlock,);
                          }
                         return Container();
                        }
                      )
                  ],
                ),


              ],
            ),
          ),
        ),
        SizedBox(height: 20 * SizeConfig.verticalBlock,),
        Divider(height: 2 * SizeConfig.verticalBlock,)
      ],
    );
  }
}
