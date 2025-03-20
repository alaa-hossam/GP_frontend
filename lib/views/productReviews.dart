import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import '../widgets/customizeProductReview.dart';

class Productreviews extends StatelessWidget {
  final List<dynamic> reviews;
  final double rate;

  // Updated constructor with named parameters and default values
  Productreviews({
    this.reviews = const [], // Default empty list
    required this.rate, // Required rate
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 120 * SizeConfig.verticalBlock, // Increased height for two rows
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
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
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

        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // First Row: "Reviews" Text
            Text(
              'Reviews',
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontSize: 20 * SizeConfig.textRatio,
              ),
            ),
            SizedBox(height: 15 * SizeConfig.verticalBlock), // Add spacing
            // Second Row: Rating and Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  rate.toStringAsFixed(1), // Display rate with 1 decimal place
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 24 * SizeConfig.textRatio,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(width: 30 * SizeConfig.horizontalBlock),
                ...List.generate(5, (index) {
                  if (index < rate) {
                    return Icon(
                      Icons.star,
                      color: Color(0xFFD4931C), // Gold color for filled stars
                      size: 30 * SizeConfig.textRatio,
                    );
                  } else {
                    return Icon(
                      Icons.star_border,
                      color: Color(0xFFD4931C), // Gold color for outlined stars
                      size: 30 * SizeConfig.textRatio,
                    );
                  }
                }),
              ],
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 30 * SizeConfig.verticalBlock,
          horizontal: 15 * SizeConfig.horizontalBlock,
        ),
        child: ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return CustomizeProductReview(
              userId: review['userId'],
              comment: review['comment'],
              rate: review['rating']?.toDouble() ?? 0.0,
              createAt: review['createdAt'],
            );
          },
        ),
      ),
    );
  }
}