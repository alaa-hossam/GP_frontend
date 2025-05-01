import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/customizeTextFormField.dart';
import '../widgets/Dimensions.dart';

class addPost extends StatefulWidget {
  static String id = "addPost";
  const addPost({super.key});

  @override
  State<addPost> createState() => _addPostState();
}

class _addPostState extends State<addPost> {
  TextEditingController description = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController duration = TextEditingController();
  TextEditingController quantity = TextEditingController();
  File? postImage;


  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null && mounted) {
      setState(() {
        postImage = File(pickedImage.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight:
        85 * SizeConfig.verticalBlock, // Set the height of the AppBar
        flexibleSpace: Container(
          decoration: const BoxDecoration(
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
          'Add Post',
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
      body: Column(
        children: [
          Container(
            height: 650 * SizeConfig.verticalBlock,
            child: ListView(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left:16 * SizeConfig.horizontalBlock,
                      right:16 * SizeConfig.horizontalBlock,
                  top: 5 * SizeConfig.verticalBlock),
                  child: MyTextFormField(
                    height: 80 * SizeConfig.verticalBlock,
                    width: 350 * SizeConfig.horizontalBlock,
                    hintName: "Write here...",
                    hintStyle: TextStyle(color: Color(0x503C3C3C)),
                    maxLines: 3,
                    controller: description,
                    labelText: "Description",
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left:16 * SizeConfig.horizontalBlock,
                      right:16 * SizeConfig.horizontalBlock,
                      top: 5 * SizeConfig.verticalBlock),
                  child: MyTextFormField(
                    height: 80 * SizeConfig.verticalBlock,
                    width: 350 * SizeConfig.horizontalBlock,
                    hintName: "Product Name",
                    hintStyle: TextStyle(color: Color(0x503C3C3C)),
                    maxLines: 3,
                    controller: title,
                    labelText: "Title",
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 16 * SizeConfig.horizontalBlock),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Price" , style: GoogleFonts.roboto(fontSize: 20 * SizeConfig.verticalBlock),),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 40 * SizeConfig.horizontalBlock,
                                  height: 40 * SizeConfig.verticalBlock,
                                  alignment: Alignment.center, // <--- Centers child

                                  decoration: BoxDecoration(
                                    border: Border.all(color: SizeConfig.iconColor, width: 2 * SizeConfig.textRatio),
                                    borderRadius: BorderRadius.all(Radius.circular(20 * SizeConfig.textRatio)),
                                  ),

                                ),
                                Positioned(
                                  left: -4 * SizeConfig.horizontalBlock,
                                  top: -11 * SizeConfig.verticalBlock,
                                  child:IconButton(
                                    onPressed: () {
                                      int currentValue = int.tryParse(price.text) ?? 0;
                                      if (currentValue > 0) {
                                        price.text = (currentValue - 1).toString();
                                      }
                                    },
                                    icon: Icon(Icons.minimize_outlined),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(16 * SizeConfig.horizontalBlock),
                              child: MyTextFormField(
                                type: TextInputType.number,
                                width: 150 * SizeConfig.horizontalBlock,
                                hintName: "0.00",
                                hintStyle: TextStyle(color: Color(0x503C3C3C) , fontSize: 20),
                                maxLines: 3,
                                controller: price,
                              ),
                            ),
                            Stack(
                              children: [
                                Container(
                                  width: 40 * SizeConfig.horizontalBlock,
                                  height: 40 * SizeConfig.verticalBlock,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: SizeConfig.iconColor, width: 2 * SizeConfig.textRatio),
                                    borderRadius: BorderRadius.all(Radius.circular(20 * SizeConfig.textRatio)),
                                  ),

                                ),
                                Positioned(
                                  left: -4 * SizeConfig.horizontalBlock,
                                  top: -4 * SizeConfig.verticalBlock,
                                  child:IconButton(
                                    onPressed: () {
                                      int currentValue = int.tryParse(price.text) ?? 0;
                                      price.text = (currentValue + 1).toString();
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                )
                              ],
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16 * SizeConfig.horizontalBlock),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Duration" , style: GoogleFonts.roboto(fontSize: 20 * SizeConfig.verticalBlock),),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 40 * SizeConfig.horizontalBlock,
                                  height: 40 * SizeConfig.verticalBlock,
                                  alignment: Alignment.center,

                                  decoration: BoxDecoration(
                                    border: Border.all(color: SizeConfig.iconColor, width: 2 * SizeConfig.textRatio),
                                    borderRadius: BorderRadius.all(Radius.circular(20 * SizeConfig.textRatio)),
                                  ),

                                ),
                                Positioned(
                                  left: -4 * SizeConfig.horizontalBlock,
                                  top: -11 * SizeConfig.verticalBlock,
                                  child:IconButton(
                                    onPressed: () {
                                      int currentValue = int.tryParse(duration.text) ?? 0;
                                      if (currentValue > 0) {
                                        duration.text = (currentValue - 1).toString();
                                      }
                                    },
                                    icon: Icon(Icons.minimize_outlined),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(16 * SizeConfig.horizontalBlock),
                              child: MyTextFormField(
                                type: TextInputType.number,
                                width: 150 * SizeConfig.horizontalBlock,
                                hintName: "0.00",
                                hintStyle: TextStyle(color: Color(0x503C3C3C) , fontSize: 20),
                                maxLines: 3,
                                controller: duration,
                              ),
                            ),
                            Stack(
                              children: [
                                Container(
                                  width: 40 * SizeConfig.horizontalBlock,
                                  height: 40 * SizeConfig.verticalBlock,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: SizeConfig.iconColor, width: 2 * SizeConfig.textRatio),
                                    borderRadius: BorderRadius.all(Radius.circular(20 * SizeConfig.textRatio)),
                                  ),

                                ),
                                Positioned(
                                  left: -4 * SizeConfig.horizontalBlock,
                                  top: -4 * SizeConfig.verticalBlock,
                                  child:IconButton(
                                    onPressed: () {
                                      int currentValue = int.tryParse(duration.text) ?? 0;
                                      duration.text = (currentValue + 1).toString();
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16 * SizeConfig.horizontalBlock),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Quantity" , style: GoogleFonts.roboto(fontSize: 20 * SizeConfig.verticalBlock),),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 40 * SizeConfig.horizontalBlock,
                                  height: 40 * SizeConfig.verticalBlock,
                                  alignment: Alignment.center, // <--- Centers child

                                  decoration: BoxDecoration(
                                    border: Border.all(color: SizeConfig.iconColor, width: 2 * SizeConfig.textRatio),
                                    borderRadius: BorderRadius.all(Radius.circular(20 * SizeConfig.textRatio)),
                                  ),

                                ),
                                Positioned(
                                  left: -4 * SizeConfig.horizontalBlock,
                                  top: -11 * SizeConfig.verticalBlock,
                                  child:IconButton(
                                    onPressed: () {
                                      int currentValue = int.tryParse(quantity.text) ?? 0;
                                      if (currentValue > 0) {
                                        quantity.text = (currentValue - 1).toString();
                                      }
                                    },
                                    icon: Icon(Icons.minimize_outlined),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(16 * SizeConfig.horizontalBlock),
                              child: MyTextFormField(
                                type: TextInputType.number,
                                width: 150 * SizeConfig.horizontalBlock,
                                hintName: "0.00",
                                hintStyle: TextStyle(color: Color(0x503C3C3C) , fontSize: 20),
                                maxLines: 3,
                                controller: quantity,
                              ),
                            ),
                            Stack(
                              children: [
                                Container(
                                  width: 40 * SizeConfig.horizontalBlock,
                                  height: 40 * SizeConfig.verticalBlock,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: SizeConfig.iconColor, width: 2 * SizeConfig.textRatio),
                                    borderRadius: BorderRadius.all(Radius.circular(20 * SizeConfig.textRatio)),
                                  ),

                                ),
                                Positioned(
                                  left: -4 * SizeConfig.horizontalBlock,
                                  top: -4 * SizeConfig.verticalBlock,
                                  child:IconButton(
                                    onPressed: () {
                                      int currentValue = int.tryParse(quantity.text) ?? 0;
                                      quantity.text = (currentValue + 1).toString();
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                )
                              ],
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),

    );
  }
}
