import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:gp_frontend/Models/indecatorModel.dart';
import 'package:gp_frontend/ViewModels/indecatorViewModel.dart';
import 'package:gp_frontend/ViewModels/productViewModel.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:gp_frontend/widgets/catgories.dart';
import 'package:gp_frontend/widgets/customizeTextFormField.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../Providers/CategoryProvider.dart';
import '../widgets/customizeButton.dart';
import '../widgets/messages.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'finalProducts.dart';

class AddProduct extends StatefulWidget {
  static String id = "AddProductScreen";
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  productViewModel PVM = productViewModel();
  final TextEditingController productName = TextEditingController();
  final TextEditingController description = TextEditingController();
  final IndecatorViewModel IVM = IndecatorViewModel();
  File? productImage;
  bool _isLoading = false;
  int selectedTabIndex = 0;
  List<String> selectedVariations = [];
  List<String> selectedColorHexes = [];
  List<indicatorModel> selectedTags = [];
  List<SizeGroup> sizeGroups = [];
  List<VolumeGroup> volumeGroups = [];
  List<TextEditingController> materialControllers = [TextEditingController()];
  List<TextEditingController> otherControllers = [TextEditingController()];
  List<Map<String, dynamic>> variations = [];
  final List<String> allVariations = [
    'Size',
    'Volume',
    'Color',
    'Material',
    'Other'
  ];
  final List<String> sizeUnits = ["Cm", "M", "G", "Kg", "Pcs", "Set", "Other"];

  @override
  void dispose() {
    productName.dispose();
    description.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    IVM.allTags.clear();
    IVM.fetchAllTags();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false)
          .clearSelectedCategory();
    });
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

  Future<productModel> _saveData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      for (var group in sizeGroups) {
        for (var controller in group.valueControllers) {
          final value = controller.text.trim();
          if (value.isNotEmpty && group.selectedUnit != null) {
            variations.add({
              "variationType": "Size",
              "variationValue": value,
              "sizeUnit": group.selectedUnit,
            });
          }
        }
      }

      // Add volume variations
      for (var group in volumeGroups) {
        for (var controller in group.valueControllers) {
          final value = controller.text.trim();
          if (value.isNotEmpty && group.selectedUnit != null) {
            variations.add({
              "variationType": "Volume",
              "variationValue": value,
              "sizeUnit": group.selectedUnit,
            });
          }
        }
      }

      // Add color variations
      for (var hex in selectedColorHexes) {
        variations.add({
          "variationType": "Color",
          "variationValue": hex,
          "sizeUnit": "Other",
        });
      }

      // Add material variations
      for (var controller in materialControllers) {
        final value = controller.text.trim();
        if (value.isNotEmpty) {
          variations.add({
            "variationType": "Material",
            "variationValue": value,
            "sizeUnit": "Other",
          });
        }
      }

      // Add other variations
      for (var controller in otherControllers) {
        final value = controller.text.trim();
        if (value.isNotEmpty) {
          variations.add({
            "variationType": "Other",
            "variationValue": value,
            "sizeUnit": "Other",
          });
        }
      }

      final catProvider = Provider.of<CategoryProvider>(context, listen: false);

      productModel result = await PVM.addProduct(
        categoryId: catProvider.selectedCategoryId!,
        name: productName.text.trim(),
        description: description.text.trim(),
        indicatorIds: selectedTags.map((e) => e.id).toList(),
        variations: variations,
        imageFile: productImage!,
      );


      setState(() {
        _isLoading = false;
      });

      return result;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (selectedVariations.contains("Size") && sizeGroups.isEmpty) {
      sizeGroups.add(SizeGroup());
    }
    if (selectedVariations.contains("Volume") && volumeGroups.isEmpty) {
      volumeGroups.add(VolumeGroup());
    }
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
              return GestureDetector(
                onTap: () {
                  if(index < selectedTabIndex) {
                    setState(() {
                      selectedTabIndex = index;
                    });
                  }
                },
                child: Container(
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
                              productImage == null ) {
                            showCustomPopup(
                              context,
                              "Missing Information",
                              "Please fill in product name, description, image, and select whether product has variations.",
                              [],
                            );
                            return;
                          }
                          setState(() {
                            selectedTabIndex = 1;
                          });
                          }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (selectedTabIndex == 1) ...[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15 * SizeConfig.horizontalBlock,
                  vertical: 10 * SizeConfig.verticalBlock,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 10 * SizeConfig.verticalBlock,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      if (selectedVariations.contains("Size")) ...[
                        SizedBox(height: 8 * SizeConfig.verticalBlock),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "Size Unit",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: SizeConfig.textRatio * 18,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Size Values",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: SizeConfig.textRatio * 18,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: sizeGroups.asMap().entries.map((entry) {
                            final index = entry.key;
                            final group = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      // Dropdown for Size Unit
                                      Container(
                                        width: 80 * SizeConfig.horizontalBlock,
                                        height: 60 * SizeConfig.verticalBlock,
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color(0x80E9E9E9),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: group.selectedUnit,
                                            isExpanded: true,
                                            dropdownColor: const Color(
                                                0xFFE9E9E9), // optional: dropdown background
                                            items: sizeUnits.map((unit) {
                                              return DropdownMenuItem<String>(
                                                value: unit,
                                                child: Text(unit),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                group.selectedUnit = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      // First Value Text Field
                                      Expanded(
                                        child: MyTextFormField(
                                          controller:
                                              group.valueControllers.first,
                                          width:
                                              240 * SizeConfig.horizontalBlock,
                                          height: 40 * SizeConfig.verticalBlock,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete_outline,
                                            color: SizeConfig.secondColor),
                                        onPressed: () {
                                          setState(() {
                                            for (var controller
                                                in group.valueControllers) {
                                              controller.dispose();
                                            }
                                            sizeGroups.removeAt(index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  ...group.valueControllers
                                      .skip(1)
                                      .map((controller) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                              width:
                                                  88), // aligns with dropdown width
                                          Expanded(
                                            child: MyTextFormField(
                                              controller: controller,
                                              width: 240 *
                                                  SizeConfig.horizontalBlock,
                                              height:
                                                  40 * SizeConfig.verticalBlock,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: customizeButton(
                            buttonName: 'Add',
                            buttonColor: const Color(0xFF5095B0),
                            fontColor: const Color(0xFFF5F5F5),
                            width: 75 * SizeConfig.horizontalBlock,
                            height: 40 * SizeConfig.verticalBlock,
                            onClickButton: () {
                              setState(() {
                                sizeGroups.add(SizeGroup());
                              });
                            },
                          ),
                        ),
                        Divider(
                          indent: 10,
                          endIndent: 10,
                          height: 1,
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
                        Wrap(
                          spacing: 10,
                          children: [
                            // Render selected color circles
                            ...selectedColorHexes.map((hex) {
                              return CircleAvatar(
                                radius: SizeConfig.horizontalBlock * 30,
                                backgroundColor: Color(int.parse('0xFF$hex')),
                              );
                            }),

                            // Add button
                            CircleAvatar(
                              radius: SizeConfig.horizontalBlock * 30,
                              backgroundColor: const Color(0xFFE9E9E9).withOpacity(0.5),
                              foregroundColor: SizeConfig.secondColor,
                              child: IconButton(
                                icon: Icon(Icons.add, size: 20),
                                onPressed: () async {
                                  Color pickedColor = Colors.blue;
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Pick a Color"),
                                        content: SingleChildScrollView(
                                          child: ColorPicker(
                                            pickerColor: pickedColor,
                                            onColorChanged: (Color color) {
                                              pickedColor = color;
                                            },
                                            enableAlpha: false,
                                            labelTypes: [],
                                            pickerAreaHeightPercent: 0.7,
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: SizeConfig.iconColor,
                                            ),
                                            child: Text("Select", style: TextStyle(color: Colors.white)),
                                            onPressed: () {
                                              setState(() {
                                                // Modified this part to store without 0xFF
                                                String hexColor = pickedColor.value.toRadixString(16).padLeft(6, '0').substring(2).toUpperCase();
                                                if (!selectedColorHexes.contains(hexColor)) {
                                                  selectedColorHexes.add(hexColor);
                                                }
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          indent: 10,
                          endIndent: 10,
                          height: 1,
                        ),
                      ],
                      if (selectedVariations.contains("Material")) ...[
                        Text(
                          "Material",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.textRatio * 18,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        // Material TextFields
                        Column(
                          children: materialControllers.asMap().entries.map((entry) {
                            final index = entry.key;
                            final controller = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MyTextFormField(
                                      controller: controller,
                                      width: 300 * SizeConfig.horizontalBlock,
                                      height: 40 * SizeConfig.verticalBlock,
                                    ),
                                  ),
                                  if (index != 0) // Don't show delete on the first field
                                    IconButton(
                                      icon: Icon(Icons.delete_outlined, color: SizeConfig.secondColor),
                                      onPressed: () {
                                        setState(() {
                                          materialControllers.removeAt(index).dispose();
                                        });
                                      },
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: customizeButton(
                            buttonName: 'Add',
                            buttonColor: const Color(0xFF5095B0),
                            fontColor: const Color(0xFFF5F5F5),
                            width: 75 * SizeConfig.horizontalBlock,
                            height: 40 * SizeConfig.verticalBlock,
                            onClickButton: () {
                              setState(() {
                                materialControllers.add(TextEditingController());
                              });
                            },
                          ),
                        ),
                        Divider(
                          indent: 10,
                          endIndent: 10,
                          height: 1,
                        ),
                      ],
                      if (selectedVariations.contains("Volume")) ...[
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "Volume Unit",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: SizeConfig.textRatio * 18,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Volume Values",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: SizeConfig.textRatio * 18,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: volumeGroups.asMap().entries.map((entry) {
                            final index = entry.key;
                            final group = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      // Dropdown for Size Unit
                                      Container(
                                        width: 80 * SizeConfig.horizontalBlock,
                                        height: 60 * SizeConfig.verticalBlock,
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color(0x80E9E9E9),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: group.selectedUnit,
                                            isExpanded: true,
                                            dropdownColor: const Color(
                                                0xFFE9E9E9), // optional: dropdown background
                                            items: sizeUnits.map((unit) {
                                              return DropdownMenuItem<String>(
                                                value: unit,
                                                child: Text(unit),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                group.selectedUnit = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      // First Value Text Field
                                      Expanded(
                                        child: MyTextFormField(
                                          controller:
                                              group.valueControllers.first,
                                          width:
                                              240 * SizeConfig.horizontalBlock,
                                          height: 40 * SizeConfig.verticalBlock,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete_outline,
                                            color: SizeConfig.secondColor),
                                        onPressed: () {
                                          setState(() {
                                            for (var controller
                                                in group.valueControllers) {
                                              controller.dispose();
                                            }
                                            volumeGroups.removeAt(index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  ...group.valueControllers
                                      .skip(1)
                                      .map((controller) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                              width:
                                                  88), // aligns with dropdown width
                                          Expanded(
                                            child: MyTextFormField(
                                              controller: controller,
                                              width: 240 *
                                                  SizeConfig.horizontalBlock,
                                              height:
                                                  40 * SizeConfig.verticalBlock,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: customizeButton(
                            buttonName: 'Add',
                            buttonColor: const Color(0xFF5095B0),
                            fontColor: const Color(0xFFF5F5F5),
                            width: 75 * SizeConfig.horizontalBlock,
                            height: 40 * SizeConfig.verticalBlock,
                            onClickButton: () {
                              setState(() {
                                volumeGroups.add(VolumeGroup());
                              });
                            },
                          ),
                        ),
                        Divider(
                          indent: 10,
                          endIndent: 10,
                          height: 1,
                        ),
                        SizedBox(height: 10 * SizeConfig.verticalBlock),
                      ],
                      if (selectedVariations.contains("Other")) ...[
                        Text(
                          "Other",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.textRatio * 18,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        // Material TextFields
                        Column(
                          children: otherControllers.asMap().entries.map((entry) {
                            final index = entry.key;
                            final controller = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MyTextFormField(
                                      controller: controller,
                                      width: 300 * SizeConfig.horizontalBlock,
                                      height: 40 * SizeConfig.verticalBlock,
                                    ),
                                  ),
                                  if (index != 0) // Don't show delete on the first field
                                    IconButton(
                                      icon: Icon(Icons.delete_outlined, color: SizeConfig.secondColor),
                                      onPressed: () {
                                        setState(() {
                                          otherControllers.removeAt(index).dispose();
                                        });
                                      },
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: customizeButton(
                            buttonName: 'Add',
                            buttonColor: const Color(0xFF5095B0),
                            fontColor: const Color(0xFFF5F5F5),
                            width: 75 * SizeConfig.horizontalBlock,
                            height: 40 * SizeConfig.verticalBlock,
                            onClickButton: () {
                              setState(() {
                                otherControllers.add(TextEditingController());
                              });
                            },
                          ),
                        ),
                        Divider(
                          indent: 10,
                          endIndent: 10,
                          height: 1,
                        ),
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
                            if (selectedVariations.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text("Please select at least one variation"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }

                            // Validate Size variations
                            if (selectedVariations.contains("Size")) {
                              for (var group in sizeGroups) {
                                if (group.selectedUnit == null || group.selectedUnit!.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Error"),
                                      content: Text("Please select a unit for all Size variations"),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text("OK"),
                                        ),
                                      ],
                                    ),
                                  );
                                  return;
                                }

                                bool hasEmptyValues = group.valueControllers.any((controller) => controller.text.isEmpty);
                                if (hasEmptyValues || group.valueControllers.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Error"),
                                      content: Text("Please fill all Size values"),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text("OK"),
                                        ),
                                      ],
                                    ),
                                  );
                                  return;
                                }
                              }
                            }

                            // Validate Volume variations (same as Size)
                            if (selectedVariations.contains("Volume")) {
                              for (var group in volumeGroups) {
                                if (group.selectedUnit == null || group.selectedUnit!.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Error"),
                                      content: Text("Please select a unit for all Volume variations"),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text("OK"),
                                        ),
                                      ],
                                    ),
                                  );
                                  return;
                                }

                                bool hasEmptyValues = group.valueControllers.any((controller) => controller.text.isEmpty);
                                if (hasEmptyValues || group.valueControllers.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Error"),
                                      content: Text("Please fill all Volume values"),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text("OK"),
                                        ),
                                      ],
                                    ),
                                  );
                                  return;
                                }
                              }
                            }

                            // Validate Color variations
                            if (selectedVariations.contains("Color") && selectedColorHexes.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text("Please add at least one color"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }

                            // Validate Material variations
                            if (selectedVariations.contains("Material")) {
                              bool hasEmptyMaterials = materialControllers.isEmpty ||
                                  materialControllers.any((controller) => controller.text.isEmpty);
                              if (hasEmptyMaterials) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Error"),
                                    content: Text("Please fill all Material fields"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("OK"),
                                      ),
                                    ],
                                  ),
                                );
                                return;
                              }
                            }

                            // Validate Other variations
                            if (selectedVariations.contains("Other")) {
                              bool hasEmptyOthers = otherControllers.isEmpty ||
                                  otherControllers.any((controller) => controller.text.isEmpty);
                              if (hasEmptyOthers) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Error"),
                                    content: Text("Please fill all Other variation fields"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("OK"),
                                      ),
                                    ],
                                  ),
                                );
                                return;
                              }
                            }

                            // If all validations pass, proceed to next tab
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
          if (selectedTabIndex == 2) ...[
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15 * SizeConfig.horizontalBlock,
                        vertical: 10 * SizeConfig.verticalBlock,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Choose only 5 tags",
                            style: TextStyle(
                              fontSize: 18 * SizeConfig.textRatio,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10 * SizeConfig.verticalBlock),
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 2.5,
                              children: IVM.allTags.map((tag) {
                                final isSelected = selectedTags.contains(tag);
                                return SizedBox(
                                  width: double
                                      .infinity, // Force full width in Grid cell
                                  child: ChoiceChip(
                                    checkmarkColor: SizeConfig.secondColor,
                                    selectedColor:
                                        Color(0xFFE9E9E9).withOpacity(0.5),
                                    label: Center(
                                      // Center text
                                      child: Text(
                                        tag.name,
                                        style: TextStyle(
                                          color: SizeConfig.iconColor,
                                          fontSize: 15 * SizeConfig.textRatio,
                                        ),
                                      ),
                                    ),
                                    selected: isSelected,
                                    backgroundColor:
                                        Color(0xFFE9E9E9).withOpacity(0.5),
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          if (selectedTags.length < 5) {
                                            selectedTags.add(tag);
                                          } else {
                                            showCustomPopup(
                                              context,
                                              "Warning",
                                              "Choose only 5 tags",
                                              [],
                                            );
                                          }
                                        } else {
                                          selectedTags.remove(tag);
                                        }
                                      });
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 10 * SizeConfig.verticalBlock,
                    ),
                    child: Center(
                      child: customizeButton(
                        buttonName: 'Next Step',
                        buttonColor: const Color(0xFF5095B0),
                        fontColor: const Color(0xFFF5F5F5),
                        width: 200 * SizeConfig.horizontalBlock,
                        height: 50 * SizeConfig.verticalBlock,
                        onClickButton: () async {
                          if (selectedTags.length < 1) {
                            showCustomPopup(
                              context,
                              "Warning",
                              "Choose at least 1 tag",
                              [],
                            );
                            return; // Prevent proceeding
                          }

                          // Optional: Validate other required fields
                          if (productName.text.trim().isEmpty || description.text.trim().isEmpty) {
                            showCustomPopup(
                              context,
                              "Missing Info",
                              "Product name and description are required.",
                              [],
                            );
                            return;
                          }

                          if (productImage == null) {
                            showCustomPopup(
                              context,
                              "Missing Image",
                              "Please select a product image.",
                              [],
                            );
                            return;
                          }

                          // Optional debug logs
                          print('\n\n===== PRODUCT INPUT DATA =====');
                          print('- Product Name: ${productName.text}');
                          print('- Description: ${description.text}');
                          print('- Selected Tags: ${selectedTags.map((e) => e.name).toList()}');
                          print('- Selected Variations: $selectedVariations');

                          // Now call _saveData
                          final result = await _saveData();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FinalProduct(product: result),
                            ),
                          );                          // // Show result to user

                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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

class SizeGroup {
  String? selectedUnit;
  List<TextEditingController> valueControllers;

  SizeGroup({this.selectedUnit, List<TextEditingController>? valueControllers})
      : valueControllers = valueControllers ?? [TextEditingController()];
}

class VolumeGroup {
  String? selectedUnit;
  List<TextEditingController> valueControllers;

  VolumeGroup(
      {this.selectedUnit, List<TextEditingController>? valueControllers})
      : valueControllers = valueControllers ?? [TextEditingController()];
}
