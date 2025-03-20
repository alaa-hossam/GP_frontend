import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';

class AddProductReview extends StatefulWidget {
  static String id = "AddProductReviewScreen";
  final String productId , name ,categoryName , imageUrl;
  final double price;
  const AddProductReview(this.productId,this.name,this.categoryName,this.price,this.imageUrl);

  @override
  State<AddProductReview> createState() => _AddProductReviewState();
}

class _AddProductReviewState extends State<AddProductReview> {
  final TextEditingController _comment = TextEditingController();
  final double rate = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(      appBar: AppBar(
      centerTitle: true,
      toolbarHeight: 85 * SizeConfig.verticalBlock, // Set the height of the AppBar
      flexibleSpace: Container(
        decoration:const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF223F4A), // Start color
              Color(0xFF5095B0), // End color
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), // Rounded bottom-left corner
            bottomRight: Radius.circular(20), // Rounded bottom-right corner
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
        'Add reviews',
        style: GoogleFonts.rubik(
          color: Colors.white,
          fontSize: 20 * SizeConfig.textRatio,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20), // Rounded bottom-left corner
          bottomRight: Radius.circular(20), // Rounded bottom-right corner
        ),
      ),
    ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10 * SizeConfig.verticalBlock),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0 * SizeConfig.textRatio),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: Image.network(
                        widget.imageUrl,
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
                          widget.name,
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
                        widget.categoryName,
                        style: GoogleFonts.rubik(
                          color: Color(0x50000000),
                          fontSize: 11 * SizeConfig.textRatio,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5), // Add spacing
                      Text(
                        "${widget.price} E",
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
            ],
          ),
        ),
      ),
    );
  }
}
