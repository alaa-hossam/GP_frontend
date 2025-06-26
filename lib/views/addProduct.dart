import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:gp_frontend/widgets/catgories.dart';
import 'package:gp_frontend/widgets/customizeTextFormField.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/customizeButton.dart';
import '../widgets/increement_decrement_buttons.dart';
import '../widgets/messages.dart';
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
  final TextEditingController sizeUnit = TextEditingController();
  final TextEditingController sizeValue = TextEditingController();
  final List<TextEditingController> sizeValueControllers = [];
  File? productImage;
  bool _isLoading = false;
  bool? hasVariations;
  final TextEditingController price = TextEditingController();
  final TextEditingController duration = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  int selectedTabIndex = 0;

  List<String> selectedVariations = [];
  final List<String> allVariations = [
    'Size',
    'Volume',
    'Color',
    'Material',
    'Other'
  ];

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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                ['Info', 'Variations', 'Tags'].asMap().entries.map((entry) {
              final index = entry.key;
              final label = entry.value;
              final isSelected = index == selectedTabIndex;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? SizeConfig.secondColor : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2))
                        ]
                      : [],
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : SizeConfig.iconColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14 * SizeConfig.textRatio,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      body: Stack(
        children: [
          if (selectedTabIndex == 0) ...[
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15 * SizeConfig.horizontalBlock,
                  vertical: 10 * SizeConfig.verticalBlock,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5 * SizeConfig.verticalBlock,
                  children: [
                    Text(
                      "Main Photo",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.textRatio * 18,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () => _pickImage(ImageSource.gallery),
                        child: Container(
                          height: 100 * SizeConfig.horizontalBlock,
                          width: 100 * SizeConfig.horizontalBlock,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                                width: 1, color: SizeConfig.iconColor),
                            color: const Color(0x80E9E9E9),
                          ),
                          child: productImage == null
                              ? Icon(Icons.file_upload_outlined,
                                  color: SizeConfig.iconColor,
                                  size: 30 * SizeConfig.textRatio)
                              : Image.file(File(productImage!.path),
                                  fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    MyTextFormField(
                      controller: productName,
                      labelText: "Product Name",
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.textRatio * 18,
                        fontFamily: 'Roboto',
                      ),
                      width: 361 * SizeConfig.horizontalBlock,
                      maxLines: 1,
                    ),
                    Text(
                      "Category",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.textRatio * 18,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 0 * SizeConfig.verticalBlock),
                      child: categories(),
                    ),
                    MyTextFormField(
                      controller: description,
                      labelText: "Description",
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.textRatio * 18,
                        fontFamily: 'Roboto',
                      ),
                      width: 361 * SizeConfig.horizontalBlock,
                      maxLines: 5,
                    ),
                    Text(
                      "Does the product have a variations?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.textRatio * 18,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio<bool>(
                          value: true,
                          groupValue: hasVariations,
                          onChanged: (value) {
                            setState(() {
                              hasVariations = value!;
                            });
                          },
                          activeColor: SizeConfig.iconColor,
                        ),
                        const Text("Yes"),
                        Radio<bool>(
                          value: false,
                          groupValue: hasVariations,
                          onChanged: (value) {
                            setState(() {
                              hasVariations = value!;
                              selectedVariations.clear();
                            });
                          },
                          activeColor: SizeConfig.iconColor,
                        ),
                        const Text("No"),
                      ],
                    ),
                    if (hasVariations == true) ...[
                      Text("Select the variations",
                          style:
                              TextStyle(fontSize: 18 * SizeConfig.textRatio)),
                      Wrap(
                        spacing: 8.0,
                        children: allVariations.map((variation) {
                          final isSelected =
                              selectedVariations.contains(variation);
                          return ChoiceChip(
                            backgroundColor: Color(0xFFE9E9E9).withOpacity(0.5),
                            label: Text(
                              variation,
                              style: TextStyle(
                                  color: SizeConfig.iconColor,
                                  fontSize: 15 * SizeConfig.textRatio),
                            ),
                            checkmarkColor: SizeConfig.secondColor,
                            selectedColor: Color(0xFFE9E9E9).withOpacity(0.5),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedVariations.add(variation);
                                } else {
                                  selectedVariations.remove(variation);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                    if (hasVariations == false) ...[
                      incrementDecrementButtons("price", "0.00", price,
                          "ًWrite the price that suits you for one product."),
                      incrementDecrementButtons("Duration", "0.00", duration,
                          "Time taken to make one product."),
                      incrementDecrementButtons("Stock quantity", "0.00",
                          quantity, "Write the number you want."),
                    ],
                    SizedBox(height: 20 * SizeConfig.verticalBlock),
                    Center(
                      child: customizeButton(
                        buttonName: 'Next',
                        buttonColor: const Color(0xFF5095B0),
                        fontColor: const Color(0xFFF5F5F5),
                        width: 200 * SizeConfig.horizontalBlock,
                        height: 50 * SizeConfig.verticalBlock,
                        onClickButton: () {
                          if (productName.text.isEmpty ||
                              description.text.isEmpty ||
                              productImage == null ||
                              hasVariations == null) {
                            showCustomPopup(
                              context,
                              "Missing Information",
                              "Please fill in product name, description, image, and select whether product has variations.",
                              [],
                            );
                            return;
                          }

                          if (hasVariations == true) {
                            if (selectedVariations.isEmpty) {
                              showCustomPopup(
                                context,
                                "Missing Variations",
                                "Please select at least one variation before proceeding.",
                                [],
                              );
                              return;
                            }
                            setState(() {
                              selectedTabIndex = 1;
                            });
                          } else {
                            if (price.text.isEmpty ||
                                duration.text.isEmpty ||
                                quantity.text.isEmpty) {
                              showCustomPopup(
                                context,
                                "Missing Information",
                                "Please enter price, duration, and stock quantity.",
                                [],
                              );
                              return;
                            }
                            setState(() {
                              selectedTabIndex = 2;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (selectedTabIndex == 1) ...[
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15 * SizeConfig.horizontalBlock,
                  vertical: 10 * SizeConfig.verticalBlock,
                ),
                child: Column(
                  spacing: 10 * SizeConfig.verticalBlock,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (selectedVariations.contains("Size")) ...[
                      SizedBox(height: 8 * SizeConfig.verticalBlock),
                      MyTextFormField(
                        controller: sizeUnit,
                        labelText: "Size Unit",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.textRatio * 18,
                          fontFamily: 'Roboto',
                        ),
                        width: 350 * SizeConfig.horizontalBlock,
                        height: 40 * SizeConfig.verticalBlock,
                        maxLines: 1,
                      ),
                      Text(
                        "Size Value",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.textRatio * 18,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MyTextFormField(
                              controller: sizeValue,
                              width: 300 * SizeConfig.horizontalBlock,
                              height: 40 * SizeConfig.verticalBlock,
                            ),
                          ),
                          SizedBox(width: 6),
                          customizeButton(
                            buttonName: 'Add',
                            buttonColor: const Color(0xFF5095B0),
                            fontColor: const Color(0xFFF5F5F5),
                            width: 60 * SizeConfig.horizontalBlock,
                            height: 40 * SizeConfig.verticalBlock,
                            onClickButton: () {
                              if (sizeValue.text.trim().isNotEmpty) {
                                setState(() {
                                  final newController = TextEditingController(
                                      text: sizeValue.text);
                                  sizeValueControllers.add(newController);
                                  sizeValue.clear();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      ...sizeValueControllers.map((controller) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Row(
                            children: [
                              Expanded(
                                child: MyTextFormField(
                                  controller: controller,
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: SizeConfig.textRatio * 18,
                                    fontFamily: 'Roboto',
                                  ),
                                  width: 300 * SizeConfig.horizontalBlock,
                                  height: 40 * SizeConfig.verticalBlock,
                                ),
                              ),
                              SizedBox(width: 2),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    sizeValueControllers.remove(controller);
                                    controller.dispose(); // Clean up memory
                                  });
                                },
                                icon: Icon(Icons.delete,
                                    color: SizeConfig.secondColor),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      SizedBox(height: 5 * SizeConfig.verticalBlock),
                      Divider(
                        height: 1,
                        color: Colors.black26,
                        endIndent: 10,
                        indent: 10,
                      ),
                    ],
                    if (selectedVariations.contains("Color")) ...[
                      Text(
                        "Color",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.textRatio * 18,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                    if (selectedVariations.contains("Material")) ...[
                      // Add your material input field here
                    ],
                    if (selectedVariations.contains("Volume")) ...[
                      // Add your volume input field here
                    ],
                    if (selectedVariations.contains("Other")) ...[
                      // Add your custom field for 'Other' here
                    ],
                    SizedBox(height: 20 * SizeConfig.verticalBlock),
                    Center(
                      child: customizeButton(
                        buttonName: 'Next',
                        buttonColor: const Color(0xFF5095B0),
                        fontColor: const Color(0xFFF5F5F5),
                        width: 200 * SizeConfig.horizontalBlock,
                        height: 50 * SizeConfig.verticalBlock,
                        onClickButton: () {
                          setState(() {
                            selectedTabIndex = 2;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (selectedVariations == 2) ...[],
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
    );
  }
}
