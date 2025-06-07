import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/offerModel.dart';
import 'package:gp_frontend/widgets/customizeButton.dart';

import 'Dimensions.dart';

class customOffer extends StatelessWidget {
  offerModel offer;
  customOffer({super.key, required this.offer});
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20 * SizeConfig.verticalBlock,
        ),
        Container(
            height: 97 * SizeConfig.verticalBlock,
            width: 350 * SizeConfig.horizontalBlock,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${offer.description}",
                  style:
                      GoogleFonts.roboto(fontSize: 12 * SizeConfig.textRatio),
                ),
                SizedBox(
                  height: 20 * SizeConfig.verticalBlock,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Price:",
                              style: GoogleFonts.roboto(
                                  fontSize: 12 * SizeConfig.textRatio,
                                  color: Color(0x50000000)),
                            ),
                            Text(
                              "${offer.price} LE",
                              style: GoogleFonts.roboto(
                                  fontSize: 12 * SizeConfig.textRatio),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Duration:",
                              style: GoogleFonts.roboto(
                                  fontSize: 12 * SizeConfig.textRatio,
                                  color: Color(0x50000000)),
                            ),
                            Text(
                              "${offer.duration} days",
                              style: GoogleFonts.roboto(
                                  fontSize: 12 * SizeConfig.textRatio),
                            ),
                          ],
                        )
                      ],
                    ),
                      customizeButton(
                          buttonName: "Confirm",
                          buttonColor: SizeConfig.iconColor,
                          fontColor: Colors.white,
                      height: 30 * SizeConfig.verticalBlock,
                      width: 70 * SizeConfig.horizontalBlock,)
                  ],
                )
              ],
            ))
      ],
    );
  }
}
