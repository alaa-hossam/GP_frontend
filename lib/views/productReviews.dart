import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';

import '../widgets/customizeProductReview.dart';

class Productreviews extends StatefulWidget {
  static String id = "ProductReviewScreen";
  final List<dynamic> reviews;

  Productreviews({super.key, required this.reviews});

  @override
  State<Productreviews> createState() => _ProductreviewsState();
}

class _ProductreviewsState extends State<Productreviews> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 146 * SizeConfig.verticalBlock,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF223F4A),
                Color(0xFF5095B0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: SizeConfig.textRatio * 15,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Reviews',
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 20 * SizeConfig.textRatio,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: widget.reviews.asMap().entries.map((entry) {
            int index = entry.key;
            var review = entry.value; // Assuming each review is a dynamic type

            // Extract necessary fields from the review, e.g., userId, comment, rate, createAt
            return CustomizeProductReview(
              userId: review['userId'], // Adjust based on your review structure
              comment: review['comment'], // Adjust based on your review structure
              rate: review['rate'], // Assuming rate is a double
              createAt: review['createdAt'], // Adjust based on your review structure
            );
          }).toList(),
        ),
      ),
    );
  }
}
