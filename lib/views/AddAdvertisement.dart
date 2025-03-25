import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/ViewModels/AdvertisementsViewModel.dart';
import 'package:gp_frontend/views/PaymentScreen.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/Dimensions.dart';
import '../widgets/customizeButton.dart';
import '../widgets/customizeTextFormField.dart';
import 'AdvertisementsPackages.dart';
import 'Home.dart';

class Addadvertisement extends StatefulWidget {
  static String id = "Add Advertisement";
  const Addadvertisement({super.key});

  @override
  State<Addadvertisement> createState() => _AddadvertisementState();
}

class _AddadvertisementState extends State<Addadvertisement> {
  File? AdvertisementImage;
  final TextEditingController AdvertisementURL = TextEditingController();
   String Package = "";
  AdvertisementsViewModel AdsVM = AdvertisementsViewModel();
  bool tapped = false;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source, bool isProfileImage) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null && mounted) {
      setState(() {
        AdvertisementImage = File(pickedImage.path);
      });
    }
  }

  Future<String> _saveData(String Transaction) async {
    print(tapped);
    if (AdvertisementURL.text.isEmpty ||
        AdvertisementImage == null ||
        Package.isEmpty ||
        Transaction.isEmpty ||
        !tapped) {
      return "Please fill all fields";
    }

    try {
      await AdsVM.addAdvertisement(
          AdvertisementImage, AdvertisementURL.text, Package, Transaction);
      return "Data Added Successfully";
    } catch (e) {
      return "An error occurred: $e";
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
          'Add Advertisement',
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
      body: Padding(
        padding: EdgeInsets.only(
            top: 30 * SizeConfig.verticalBlock,
            right: 20 * SizeConfig.horizontalBlock,
            left: 20 * SizeConfig.horizontalBlock),
        child: ListView(
          children: [
            SizedBox(
              height:
                  SizeConfig.screenHeight - (200 * SizeConfig.horizontalBlock),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upload Ad Image (Max 5MB, JPG, PNG) ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            _pickImage(ImageSource.gallery, true);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 10 * SizeConfig.verticalBlock),
                            height: 100 * SizeConfig.horizontalBlock,
                            width: 100 * SizeConfig.horizontalBlock,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  width: 1, color: SizeConfig.iconColor),
                              color: const Color(0x80E9E9E9),
                            ),
                            child: AdvertisementImage == null
                                ? Icon(Icons.file_upload_outlined,
                                    color: SizeConfig.iconColor,
                                    size: 30 * SizeConfig.textRatio)
                                : Image.file(
                                    File(AdvertisementImage!.path),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24 * SizeConfig.verticalBlock),
                      Text(
                        "Advertisement URL",
                        style: GoogleFonts.roboto(
                            fontSize: 18 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold),
                      ),
                      MyTextFormField(
                        controller: AdvertisementURL,
                        width: 361 * SizeConfig.horizontalBlock,
                        maxLines: 1,
                        hintName: "Enter Advertisement destination URL",
                      ),
                      SizedBox(height: 16 * SizeConfig.verticalBlock),
                      Text(
                        "Advertisement Package",
                        style: GoogleFonts.roboto(
                            fontSize: 18 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        child: Container(
                          width: 363 * SizeConfig.horizontalBlock,
                          height: 60 * SizeConfig.verticalBlock,
                          color: Color(0x50E9E9E9),
                          child: Padding(
                            padding:  EdgeInsets.only(left: 10.0 * SizeConfig.horizontalBlock , right: 10.0 * SizeConfig.horizontalBlock),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Package.isEmpty ? "SelectPackage": Package,
                                  style: GoogleFonts.roboto(
                                      fontSize: 14 * SizeConfig.textRatio , color: SizeConfig.fontColor),
                                ),
                                Icon(Icons.arrow_forward_ios , size: 24 * SizeConfig.textRatio,),
                              ],
                            ),
                          ),
                        ),
                        onTap: () async {
                          final result = await Navigator.pushNamed(
                              context,
                              Advertisementspackages.id
                          );

                          if (result != null && result is String) {
                            setState(() {
                              Package = result;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 8 * SizeConfig.verticalBlock),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                tapped = !tapped;
                              });
                            },
                            icon: tapped
                                ? Icon(Icons.check_box_outlined)
                                : Icon(Icons.check_box_outline_blank),
                            color: SizeConfig.iconColor,
                          ),
                          Text(
                            "I agree to the",
                            style: GoogleFonts.roboto(
                                fontSize: 14 * SizeConfig.textRatio),
                          ),
                          GestureDetector(
                            child: Text(
                              " Advertisement Terms of Service.",
                              style: GoogleFonts.roboto(
                                  fontSize: 12 * SizeConfig.textRatio,
                                  color: SizeConfig.iconColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 65 * SizeConfig.horizontalBlock,
                    child:
                    Padding(
                      padding: EdgeInsets.all(10.0 * SizeConfig.verticalBlock),
                      child: customizeButton(
                        buttonName: 'Submit',
                        buttonColor: Color(0xFF5095B0),
                        fontColor: const Color(0xFFF5F5F5),
                        width: 200 * SizeConfig.horizontalBlock,
                        height: 50 * SizeConfig.verticalBlock,
                        onClickButton: () async {
                          setState(() {
                            _isLoading = true;
                          });

                          String response = await _saveData("123456789");

                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                            });

                            if (response == "Please fill all fields") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Please fill all fields"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else if (response == "Data Added Successfully") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Your Request Sent successfully!")),
                              );
                              Navigator.pushReplacementNamed(context, PaymentScreen.id);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(response)),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  if (_isLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black54,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: SizeConfig.iconColor,
                          ),
                        ),
                      ),
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
