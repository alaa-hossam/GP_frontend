import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gp_frontend/Models/postModel.dart';
import 'package:gp_frontend/Providers/postProvider.dart';
import 'package:gp_frontend/widgets/customizeButton.dart';
import 'package:gp_frontend/widgets/increement_decrement_buttons.dart';
import 'package:gp_frontend/widgets/messages.dart';
import 'package:gp_frontend/widgets/specializtion.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../Providers/CategoryProvider.dart';
import '../widgets/AppBar.dart';
import '../widgets/customizeTextFormField.dart';
import '../widgets/Dimensions.dart';

class addPost extends StatefulWidget {
  static String id = "addPost";
  const addPost({super.key});

  @override
  State<addPost> createState() => _addPostState();
}

class _addPostState extends State<addPost> {
  File? postImage;
  bool _isLoading = false;

  postProvider myPostProvider = postProvider();

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null && mounted) {
      setState(() {
        postImage = File(pickedImage.path);
      });
    }
  }

  Future<bool> submitOrder(postModel post, String specialization, File? image) async {
    await myPostProvider.addPost(post, specialization, image);
    return true;
  }

  void clearFields(postProvider addPostProvider) {
    addPostProvider.description.clear();
    addPostProvider.title.clear();
    addPostProvider.price.clear();
    addPostProvider.duration.clear();
    addPostProvider.quantity.clear();
    Provider.of<CategoryProvider>(context, listen: false).clearSelected();
    setState(() {
      postImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final addPostProvider = Provider.of<postProvider>(context);

    return Scaffold(
      appBar: customAppbar(
        "add Post",
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                height: 600 * SizeConfig.verticalBlock,
                child: ListView(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16 * SizeConfig.horizontalBlock,
                        vertical: 5 * SizeConfig.verticalBlock,
                      ),
                      child: MyTextFormField(
                        height: 80 * SizeConfig.verticalBlock,
                        width: 350 * SizeConfig.horizontalBlock,
                        hintName: "Write here...",
                        hintStyle: TextStyle(color: Color(0x503C3C3C)),
                        maxLines: 3,
                        controller: addPostProvider.description,
                        labelText: "Description",
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16 * SizeConfig.horizontalBlock,
                        vertical: 5 * SizeConfig.verticalBlock,
                      ),
                      child: MyTextFormField(
                        height: 80 * SizeConfig.verticalBlock,
                        width: 350 * SizeConfig.horizontalBlock,
                        hintName: "Product Name",
                        hintStyle: TextStyle(color: Color(0x503C3C3C)),
                        maxLines: 3,
                        controller: addPostProvider.title,
                        labelText: "Title",
                      ),
                    ),
                    incrementDecrementButtons(
                        "price", "0.00", addPostProvider.price, "ًWrite an estimated price that suits you for the whole."),
                    incrementDecrementButtons("Duration", "0.00", addPostProvider.duration,
                        "Write an estimated time you can wait for the order to be completed."),
                    incrementDecrementButtons(
                        "Quantity", "0.00", addPostProvider.quantity, "Write the number you want."),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20 * SizeConfig.horizontalBlock,
                          bottom: 10 * SizeConfig.verticalBlock),
                      child: Text(
                        "Specializations",
                        style: TextStyle(fontSize: 20 * SizeConfig.textRatio),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16 * SizeConfig.horizontalBlock,
                        vertical: 10 * SizeConfig.verticalBlock,
                      ),
                      child: specializtions(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16 * SizeConfig.horizontalBlock),
                      child: Text(
                        "Upload post Image (Max 5MB, JPG, PNG) ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _pickImage(ImageSource.gallery);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10 * SizeConfig.verticalBlock),
                          height: 100 * SizeConfig.horizontalBlock,
                          width: 100 * SizeConfig.horizontalBlock,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border.all(width: 1, color: SizeConfig.iconColor),
                            color: const Color(0x80E9E9E9),
                          ),
                          child: postImage == null
                              ? Icon(Icons.file_upload_outlined,
                              color: SizeConfig.iconColor, size: 30 * SizeConfig.textRatio)
                              : Image.file(
                            File(postImage!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16 * SizeConfig.horizontalBlock,
                  vertical: 10 * SizeConfig.verticalBlock,
                ),
                child: customizeButton(
                  buttonName: "Add Post",
                  buttonColor: SizeConfig.iconColor,
                  fontColor: Colors.white,
                    onClickButton: () async {
                      final catProvider = Provider.of<CategoryProvider>(context, listen: false);

                      if (addPostProvider.title.text.trim().isEmpty ||
                          addPostProvider.description.text.trim().isEmpty ||
                          addPostProvider.price.text.trim().isEmpty ||
                          addPostProvider.duration.text.trim().isEmpty ||
                          addPostProvider.quantity.text.trim().isEmpty ||
                          catProvider.selectedSpecializationId == null ||
                          catProvider.selectedSpecializationId!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please fill in all fields and select at least one specialization")),
                        );
                        return;
                      }


                      setState(() {
                        _isLoading = true;
                      });

                      final selectedSpecializations = catProvider.selectedSpecializationId!;

                      try {
                        bool success = await submitOrder(
                          postModel(
                            description: addPostProvider.description.text,
                            title: addPostProvider.title.text,
                            price: double.parse(addPostProvider.price.text),
                            duration: int.parse(addPostProvider.duration.text),
                            quantity: int.parse(addPostProvider.quantity.text),
                          ),
                          selectedSpecializations,
                          postImage,
                        );

                        if (success && mounted) {
                          clearFields(addPostProvider);
                          Navigator.pop(context, true);
                        } else {
                          showCustomPopup(context, "Post", "Failed to add post", []);

                        }
                      } catch (e) {
                        showCustomPopup(context, "Post", "${e.toString()}", []);
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    }
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
