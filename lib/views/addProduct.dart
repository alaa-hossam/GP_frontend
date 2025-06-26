import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:gp_frontend/widgets/customizeTextFormField.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/customizeButton.dart';
import '../widgets/specializtion.dart';

class AddProduct extends StatefulWidget {
  static String id = "AddProductScreen";
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController productName = TextEditingController();
  final TextEditingController description = TextEditingController();
  File? productImage;
  bool _isLoading = false;
  late bool variation ;

  @override
  void dispose() {
    productName.dispose();
    description.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null && mounted) {
      setState(() {
        productImage = File(pickedImage.path);
      });
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
          'Add Product',
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16 * SizeConfig.horizontalBlock,
                vertical: 16 * SizeConfig.verticalBlock,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10 * SizeConfig.verticalBlock,
                children: [
                  Text(
                    "Main Photo",
                    style: TextStyle(
                      fontSize: 20 * SizeConfig.textRatio,
                      fontFamily: "Roboto",
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _pickImage(ImageSource.gallery);
                      },
                      child: Container(
                        height: 100 * SizeConfig.horizontalBlock,
                        width: 100 * SizeConfig.horizontalBlock,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(width: 1, color: SizeConfig.iconColor),
                          color: const Color(0x80E9E9E9),
                        ),
                        child: productImage == null
                            ? Icon(Icons.file_upload_outlined,
                            color: SizeConfig.iconColor,
                            size: 30 * SizeConfig.textRatio)
                            : Image.file(
                          File(productImage!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  MyTextFormField(
                    controller: productName,
                    labelText: "Product Name",
                    width: 361 * SizeConfig.horizontalBlock,
                    maxLines: 1,
                  ),
                  Text(
                    "Category",
                    style: TextStyle(fontSize: 20 * SizeConfig.textRatio),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 0 * SizeConfig.verticalBlock,
                    ),
                    child: specializtions(),
                  ),
                  MyTextFormField(
                    controller: description,
                    labelText: "Description",
                    width: 361 * SizeConfig.horizontalBlock,
                    maxLines: 5,
                  ),
                  Text(
                    "Does the product have a variations?",
                    style: TextStyle(fontSize: 20 * SizeConfig.textRatio),
                  ),
                  Center(
                    child: customizeButton(
                      buttonName: 'Next',
                      buttonColor: Color(0xFF5095B0),
                      fontColor: const Color(0xFFF5F5F5),
                      width: 200 * SizeConfig.horizontalBlock,
                      height: 50 * SizeConfig.verticalBlock,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(color: SizeConfig.iconColor,),
                ),
              ),
            ),
        ],
      ),
    );
  }
}