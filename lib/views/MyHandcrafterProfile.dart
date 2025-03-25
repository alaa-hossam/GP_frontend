import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../Providers/ProductProvider.dart';
import '../widgets/customProduct.dart';
import '../widgets/customizeButton.dart';

class MyHandcrafterProfile extends StatefulWidget {
  static String id = "MyHandcrafterProfileScreen";
  const MyHandcrafterProfile({super.key});

  @override
  State<MyHandcrafterProfile> createState() => _MyHandcrafterProfileState();
}

class _MyHandcrafterProfileState extends State<MyHandcrafterProfile> {
  File? _image;
  late productProvider prodProvider;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  double _calculateButtonWidth(String text, BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 14 * SizeConfig.textRatio,
          fontFamily: "Roboto",
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Add some padding (20 on each side)
    return textPainter.width + 40 * SizeConfig.horizontalBlock;
  }

  @override
  void initState() {
    super.initState();
    prodProvider = Provider.of<productProvider>(context, listen: false);

    prodProvider.products.clear();
    prodProvider.fetchProducts('0');
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 308 * SizeConfig.verticalBlock,
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
        leading: null,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10 * SizeConfig.verticalBlock,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: SizeConfig.textRatio * 15,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  'My Profile',
                  style: TextStyle(
                    fontFamily: "Rubik",
                    fontSize: 20 * SizeConfig.textRatio,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            // Profile content below
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: SizeConfig.iconColor,
                    radius: SizeConfig.horizontalBlock * 70,
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/BPM.png'),
                      radius: SizeConfig.horizontalBlock * 67,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      backgroundColor: Color(0xFFB36995),
                      radius: SizeConfig.horizontalBlock * 20,
                      child: IconButton(
                        onPressed: () {
                          _pickImage(ImageSource.gallery);
                        },
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: SizeConfig.textRatio * 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Text(
                'name',
                style: TextStyle(
                  fontFamily: "Rubik",
                  fontSize: 24 * SizeConfig.textRatio,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              'description',
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 16 * SizeConfig.textRatio,
                color: Colors.white,
              ),
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
      body: SingleChildScrollView(
        child: Column(
          spacing: 15 * SizeConfig.verticalBlock,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 15 * SizeConfig.verticalBlock,
              ),
              child: SizedBox(
                height: 50 * SizeConfig.verticalBlock,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SizedBox(width: 10 * SizeConfig.horizontalBlock),
                    customizeButton(
                      buttonName: "Add Product",
                      buttonColor: Color(0xFF5095B0),
                      fontColor: Color(0xFFFFFFFF),
                      buttonIcon: Icons.add,
                      IconColor: Color(0xFFFFFFFF),
                      textSize: 14 * SizeConfig.textRatio,
                      width: _calculateButtonWidth("Add Product", context),
                      height: 40 * SizeConfig.verticalBlock,
                    ),
                    SizedBox(width: 10 * SizeConfig.horizontalBlock),
                    customizeButton(
                      buttonName: "Add Reel",
                      buttonColor: Color(0xFFE9E9E9).withOpacity(0.5),
                      fontColor: SizeConfig.iconColor,
                      buttonIcon: Icons.add,
                      IconColor: SizeConfig.iconColor,
                      textSize: 14 * SizeConfig.textRatio,
                      width: _calculateButtonWidth("Add Reel", context),
                      height: 40 * SizeConfig.verticalBlock,
                    ),
                    SizedBox(width: 10 * SizeConfig.horizontalBlock),
                    customizeButton(
                      buttonName: "Edit Theme",
                      buttonColor: Color(0xFFE9E9E9).withOpacity(0.5),
                      fontColor: SizeConfig.iconColor,
                      buttonIcon: Icons.edit_outlined,
                      IconColor: SizeConfig.iconColor,
                      textSize: 14 * SizeConfig.textRatio,
                      width: _calculateButtonWidth("Edit Theme", context),
                      height: 40 * SizeConfig.verticalBlock,
                    ),
                    SizedBox(width: 10 * SizeConfig.horizontalBlock),
                  ],
                ),
              ),
            ),
            Divider(
              height: 2,
              color: Color(0xFF3C3C3C).withOpacity(0.5),
              indent: 70 * SizeConfig.horizontalBlock,
              endIndent: 70 * SizeConfig.horizontalBlock,
            ),
            SizedBox(
              height: 50 * SizeConfig.verticalBlock,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(width: 10 * SizeConfig.horizontalBlock),
                  customizeButton(
                    buttonName: "Products",
                    buttonColor: Color(0xFF5095B0),
                    fontColor: Color(0xFFFFFFFF),
                    textSize: 14 * SizeConfig.textRatio,
                    width: _calculateButtonWidth("Products", context),
                    height: 40 * SizeConfig.verticalBlock,
                  ),
                  SizedBox(width: 10 * SizeConfig.horizontalBlock),
                  customizeButton(
                    buttonName: "Reels",
                    buttonColor: Color(0xFFE9E9E9).withOpacity(0.5),
                    fontColor: SizeConfig.iconColor,
                    textSize: 14 * SizeConfig.textRatio,
                    width: _calculateButtonWidth("Reels", context),
                    height: 40 * SizeConfig.verticalBlock,
                  ),
                  SizedBox(width: 10 * SizeConfig.horizontalBlock),
                  customizeButton(
                    buttonName: "Analysis",
                    buttonColor: Color(0xFFE9E9E9).withOpacity(0.5),
                    fontColor: SizeConfig.iconColor,
                    textSize: 14 * SizeConfig.textRatio,
                    width: _calculateButtonWidth("Analysis", context),
                    height: 40 * SizeConfig.verticalBlock,
                  ),
                  SizedBox(width: 10 * SizeConfig.horizontalBlock),
                  customizeButton(
                    buttonName: "Orders",
                    buttonColor: Color(0xFFE9E9E9).withOpacity(0.5),
                    fontColor: SizeConfig.iconColor,
                    textSize: 14 * SizeConfig.textRatio,
                    width: _calculateButtonWidth("Orders", context),
                    height: 40 * SizeConfig.verticalBlock,
                  ),
                  SizedBox(width: 10 * SizeConfig.horizontalBlock),
                ],
              ),
            ),
            Consumer<productProvider>(
              builder: (context, prodProvider, child) {
                if (prodProvider.products.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0,right: 8,left: 8),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // Disable GridView's scrolling
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two products per row
                      crossAxisSpacing: 10.0, // Spacing between columns
                      mainAxisSpacing: 10.0, // Spacing between rows
                      childAspectRatio: 0.7, // Adjust based on your design
                    ),
                    itemCount: prodProvider.products.length,
                    itemBuilder: (context, index) {
                      var product = prodProvider.products[index];
                      return customProduct(
                        product.imageURL,
                        product.name,
                        Category:product.category,
                        product.price,
                        product.rate,
                        product.id,
                        false,
                      );
                    },
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
