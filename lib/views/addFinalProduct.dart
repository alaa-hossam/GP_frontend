import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:image_picker/image_picker.dart';
import '../ViewModels/productViewModel.dart';
import '../widgets/customizeButton.dart';
import '../widgets/customizeTextFormField.dart';

class AddFinalProduct extends StatefulWidget {
  static String id = "AddFinalProductScreen";
  final List<dynamic>? variations;
  final String productId;

  const AddFinalProduct(this.productId, {super.key, this.variations});

  @override
  State<AddFinalProduct> createState() => _AddFinalProductState();
}

class _AddFinalProductState extends State<AddFinalProduct> {
  File? _mainImage;
  List<File?> _galleryImages = [];
  Map<String, String> selectedVariationValues = {}; // type -> value
  Map<String, String> selectedVariationIds = {}; // type -> id
  final TextEditingController price = TextEditingController();
  final TextEditingController duration = TextEditingController();
  final TextEditingController stockQuantity = TextEditingController();
  bool? isCustom;
  productViewModel PVM = productViewModel();
  bool _isLoading = false;

  void _showImagePickerOptions({required bool isMainImage, int? galleryIndex}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Choose from gallery'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery, isMainImage, galleryIndex);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a photo'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera, isMainImage, galleryIndex);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(
      ImageSource source, bool isMainImage, int? galleryIndex) async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: source);

      if (pickedImage != null) {
        setState(() {
          if (isMainImage) {
            _mainImage = File(pickedImage.path);
          } else if (galleryIndex != null) {
            _galleryImages[galleryIndex] = File(pickedImage.path);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }


  Future<void> _saveData() async {
    if (_mainImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a main image')),
      );
      return;
    }

    if (price.text.isEmpty || isCustom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all required fields')),
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final double parsedPrice = double.tryParse(price.text) ?? 0.0;
      final int? parsedDuration =
      isCustom == false ? int.tryParse(duration.text) : null;
      final int? parsedStockQuantity =
      isCustom == false ? int.tryParse(stockQuantity.text) : null;

      final result = await PVM.addFinalProduct(
        productId: widget.productId,
        duration: parsedDuration ?? 0, // You can handle null in ViewModel
        stockquntity: parsedStockQuantity ?? 0,
        isCustom: isCustom!,
        price: parsedPrice,
        varitionIds: selectedVariationIds.values.toList(),
        galleryImages: _galleryImages.whereType<File>().toList(),
        imageFile: _mainImage!,
      );

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
      Navigator.pop(context); // Or navigate somewhere else

    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }



  Widget _buildImageContainer({
    File? image,
    required VoidCallback onTap,
    required bool isMain,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: const Color(0x80E9E9E9),
              border: Border.all(color: SizeConfig.iconColor),
              borderRadius: BorderRadius.circular(6),
            ),
            child: image == null
                ? Icon(Icons.file_upload_outlined,
                    size: 30, color: SizeConfig.iconColor)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(image, fit: BoxFit.cover),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddGalleryImageButton() {
    final bool canAdd = _galleryImages.isEmpty || _galleryImages.last != null;

    return GestureDetector(
      onTap: canAdd
          ? () {
              setState(() {
                _galleryImages.add(null);
              });
            }
          : null,
      child: Opacity(
        opacity: canAdd ? 1.0 : 0.4,
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: const Color(0x80E9E9E9),
            border: Border.all(color: SizeConfig.iconColor),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(Icons.add, size: 30, color: SizeConfig.iconColor),
        ),
      ),
    );
  }

  Color _parseColor(String colorValue) {
    try {
      return Color(int.parse('0xFF$colorValue'));
    } catch (_) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    // Grouping logic
    Map<String, List<Map<String, String>>> groupedByType = {};
    for (var variation in widget.variations ?? []) {
      final type = variation['variationType'];
      final value = variation['variationValue'];
      final id = variation['id'];

      if (type != null && value != null && id != null) {
        groupedByType.putIfAbsent(type, () => []).add({
          'value': value.toString(),
          'id': id.toString(),
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 85 * SizeConfig.verticalBlock,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF223F4A), Color(0xFF5095B0)],
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
          icon: Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: SizeConfig.textRatio * 15),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Add Final Products',
            style: GoogleFonts.rubik(
                color: Colors.white, fontSize: 20 * SizeConfig.textRatio)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
      ),
      body: Stack(
        children:[ SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 16 * SizeConfig.horizontalBlock,
            vertical: 16 * SizeConfig.verticalBlock,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Photos',
                style: TextStyle(
                    fontSize: 20 * SizeConfig.textRatio,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Roboto"),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  Column(
                    children: [
                      _buildImageContainer(
                        image: _mainImage,
                        onTap: () => _showImagePickerOptions(isMainImage: true),
                        isMain: true,
                      ),
                      const SizedBox(height: 4),
                      Text('Main photo',
                          style: TextStyle(
                              fontSize: 12 * SizeConfig.textRatio,
                              color: Colors.grey)),
                    ],
                  ),
                  ..._galleryImages.asMap().entries.map((entry) {
                    int index = entry.key;
                    File? img = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _buildImageContainer(
                        image: img,
                        onTap: () => _showImagePickerOptions(
                            isMainImage: false, galleryIndex: index),
                        isMain: false,
                      ),
                    );
                  }).toList(),
                  _buildAddGalleryImageButton(),
                ],
              ),
              const SizedBox(height: 20),
              ...groupedByType.entries.map((entry) {
                final type = entry.key;
                final items = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type,
                        style: TextStyle(
                            fontSize: 20 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Roboto"),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: items.map((item) {
                            final value = item['value']!;
                            final id = item['id']!;
                            final isSelected = selectedVariationIds[type] == id;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedVariationIds[type] = id;
                                  selectedVariationValues[type] = value;
                                });
                              },
                              child: type.toLowerCase() == "color"
                                  ? Container(
                                      width: 60 * SizeConfig.verticalBlock,
                                      height: 60 * SizeConfig.verticalBlock,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _parseColor(value),
                                        border: Border.all(
                                          color: isSelected
                                              ? SizeConfig.secondColor
                                              : SizeConfig.iconColor,
                                          width: isSelected ? 3 : 1,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isSelected
                                              ? SizeConfig.secondColor
                                              : SizeConfig.iconColor,
                                          width: isSelected ? 3 : 1,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            fontSize: 13 * SizeConfig.textRatio),
                                      ),
                                    ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              MyTextFormField(
                type: TextInputType.number,
                controller: price,
                labelText: "Price",
                labelStyle: TextStyle(
                    fontSize: 20 * SizeConfig.textRatio,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Roboto"),
                width: 361 * SizeConfig.horizontalBlock,
                maxLines: 1,
              ),
              SizedBox(
                height: 10 * SizeConfig.verticalBlock,
              ),
              Text("Is the custom product ?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.textRatio * 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: isCustom,
                    onChanged: (value) {
                      setState(() {
                        isCustom = value!;
                      });
                    },
                    activeColor: SizeConfig.iconColor,
                  ),
                  const Text("Yes"),
                  Radio<bool>(
                    value: false,
                    groupValue: isCustom,
                    onChanged: (value) {
                      setState(() {
                        isCustom = value!;
                      });
                    },
                    activeColor: SizeConfig.iconColor,
                  ),
                  const Text("No"),
                ],
              ),
              if (isCustom == false) ...[
                MyTextFormField(
                  type: TextInputType.number,
                  controller: duration,
                  labelText: "Duration",
                  labelStyle: TextStyle(
                      fontSize: 20 * SizeConfig.textRatio,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto"),
                  width: 361 * SizeConfig.horizontalBlock,
                  maxLines: 1,
                ),
                MyTextFormField(
                  type: TextInputType.number,
                  controller: stockQuantity,
                  labelText: "Stock Quantity",
                  labelStyle: TextStyle(
                      fontSize: 20 * SizeConfig.textRatio,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto"),
                  width: 361 * SizeConfig.horizontalBlock,
                  maxLines: 1,
                ),
              ],
              SizedBox(
                height: 20 * SizeConfig.verticalBlock,
              ),
              Center(
                child: customizeButton(
                  buttonName: 'Add',
                  buttonColor: const Color(0xFF5095B0),
                  fontColor: const Color(0xFFF5F5F5),
                  width: 200 * SizeConfig.horizontalBlock,
                  height: 50 * SizeConfig.verticalBlock,
                  onClickButton: () async {
                    final result = await _saveData();
                  },

                ),
              ),
            ],
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
    );
  }
}
