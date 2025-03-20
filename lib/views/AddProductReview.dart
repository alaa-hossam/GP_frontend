import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/ViewModels/productViewModel.dart';
import 'package:gp_frontend/views/Home.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:gp_frontend/widgets/customizeButton.dart';
import 'package:gp_frontend/widgets/customizeTextFormField.dart';

class AddProductReview extends StatefulWidget {
  static String id = "AddProductReviewScreen";
  final String productId, name, categoryName, imageUrl;
  final double price;
  const AddProductReview(
      this.productId, this.name, this.categoryName, this.price, this.imageUrl);

  @override
  State<AddProductReview> createState() => _AddProductReviewState();
}

class _AddProductReviewState extends State<AddProductReview> {
  final TextEditingController _comment = TextEditingController();
  double _rating = 0; // Track the selected rating
  final int _maxCharacters = 300; // Maximum allowed characters
  productViewModel PVM = productViewModel();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _comment.addListener(_updateCharacterCount); // Listen to text changes
  }

  @override
  void dispose() {
    _comment.removeListener(_updateCharacterCount); // Remove listener
    _comment.dispose();
    super.dispose();
  }

  // Update the character count
  void _updateCharacterCount() {
    setState(() {}); // Rebuild the UI to update the character counter
  }

  Future<String> addReview() async {
    print("Commmmment ");
    print(_comment.text);
    print("productIDDDDDDDD ${widget.productId}");
    print("Ratinnnnnnng $_rating");
    try {
      return await PVM.addProductReview(
          _comment.text, widget.productId, _rating);
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 85 * SizeConfig.verticalBlock,
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
        title: Text(
          'Add reviews',
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 20 * SizeConfig.textRatio,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: Stack(children: [
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15 * SizeConfig.horizontalBlock,
                    vertical: 25 * SizeConfig.verticalBlock,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 110 * SizeConfig.verticalBlock,
                        width: 358 * SizeConfig.horizontalBlock,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(
                            width: 2 * SizeConfig.textRatio,
                            color: SizeConfig.iconColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.all(8.0 * SizeConfig.textRatio),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                child: Image.network(
                                  widget.imageUrl,
                                  width: 100 * SizeConfig.horizontalBlock,
                                  height: 100 * SizeConfig.verticalBlock,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 150 * SizeConfig.horizontalBlock,
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
                                Text(
                                  widget.categoryName,
                                  style: GoogleFonts.rubik(
                                    color: Color(0x50000000),
                                    fontSize: 11 * SizeConfig.textRatio,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10 * SizeConfig.verticalBlock),
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
                      ),
                      SizedBox(height: 20 * SizeConfig.verticalBlock),
                      Text(
                        "Your overall rating",
                        style: TextStyle(
                          color: Color(0xFF3C3C3C).withOpacity(0.5),
                          fontSize: 16 * SizeConfig.textRatio,
                          fontFamily: "Roboto",
                        ),
                      ),
                      SizedBox(height: 10 * SizeConfig.verticalBlock),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _rating = index + 1; // Update the rating
                              });
                            },
                            child: Icon(
                              index < _rating ? Icons.star : Icons.star_border,
                              color: index < _rating
                                  ? Color(0xFFD4931C)
                                  : Color(0xFFD4931C),
                              size: 40 * SizeConfig.textRatio,
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 20 * SizeConfig.verticalBlock),
                      MyTextFormField(
                        controller: _comment,
                        hintName: "Enter here",
                        labelText: "Add detailed review",
                        width: 358 * SizeConfig.horizontalBlock,
                        height: 144 * SizeConfig.verticalBlock,
                        fillColor: Colors.transparent,
                        maxLength:
                            _maxCharacters, // Limit the number of characters
                        onChanged: (value) {
                          setState(
                              () {}); // Rebuild the UI to update the character counter
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${_maxCharacters - _comment.text.length} characters remaining",
                            style: TextStyle(
                              color: Color(0xFF3C3C3C).withOpacity(0.5),
                              fontSize: 16 * SizeConfig.textRatio,
                              fontFamily: "Roboto",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15 * SizeConfig.horizontalBlock),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customizeButton(
                    buttonName: "Cancel",
                    buttonColor: Color(0xFFE9E9E9).withOpacity(0.5),
                    fontColor: SizeConfig.iconColor,
                    width: 173 * SizeConfig.horizontalBlock,
                    rad: 5,
                    onClickButton: () {
                      Navigator.pop(context); // Close the screen
                    },
                  ),
                  customizeButton(
                    buttonName: "Submit",
                    buttonColor: SizeConfig.iconColor,
                    fontColor: Colors.white,
                    width: 173 * SizeConfig.horizontalBlock,
                    rad: 5,
                    onClickButton: () async {
                      setState(() {
                        _isLoading = true;
                      });

                      String response = await addReview();

                      setState(() {
                        _isLoading = false;
                      });

                      if (response == "review sent successfully") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("review sent successfully!")),
                        );
                        Navigator.pushReplacementNamed(context, Home.id);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response)),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ]),
    );
  }
}
