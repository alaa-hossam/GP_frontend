import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/Models/postModel.dart';
import 'package:gp_frontend/Providers/postProvider.dart';
import 'package:gp_frontend/widgets/customizeButton.dart';
import 'package:gp_frontend/widgets/increement_decrement_buttons.dart';
import 'package:gp_frontend/widgets/messages.dart';
import 'package:gp_frontend/widgets/specializtion.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../Providers/CategoryProvider.dart';
import '../widgets/AppBar.dart';
import '../widgets/customizeTextFormField.dart';
import '../widgets/Dimensions.dart';

class addPost extends StatefulWidget {
  static String id = "addPost";
  final String? image;
  const addPost({super.key, this.image});

  @override
  State<addPost> createState() => _addPostState();
}

class _addPostState extends State<addPost> {
  File? postImage;
  bool _isLoading = false;
  String? imagePath;
  bool isUpdate = false;
  bool disableImageAndSpecialization = false;

  postProvider myPostProvider = postProvider();

  Future<void> _pickImage(ImageSource source) async {
    if (disableImageAndSpecialization) return;

    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null && mounted) {
      setState(() {
        postImage = File(pickedImage.path);
      });
    }
  }

  Future<File?> downloadImageFromUrl(String imageUrl) async {
    try {
      final uri = Uri.parse(imageUrl);
      final response = await HttpClient().getUrl(uri).then((req) => req.close());
      final bytes = await consolidateHttpClientResponseBytes(response);
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/uploaded_image.jpg');
      await tempFile.writeAsBytes(bytes);
      return tempFile;
    } catch (e) {
      print("Image download failed: $e");
      return null;
    }
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
      imagePath = "";
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null && args['type'] == "update") {
        final post = args['post'] as postModel;
        final addPostProvider = Provider.of<postProvider>(context, listen: false);
        final catProvider = Provider.of<CategoryProvider>(context, listen: false);

        setState(() {
          isUpdate = true;
          disableImageAndSpecialization = true;
          imagePath = post.postImage;
        });

        addPostProvider.title.text = post.title ?? '';
        addPostProvider.description.text = post.description ?? '';
        addPostProvider.price.text = post.price?.toString() ?? '';
        addPostProvider.duration.text = post.duration?.toString() ?? '';
        addPostProvider.quantity.text = post.quantity?.toString() ?? '';

        if (post.specialName != null && post.specialId != null) {
          catProvider.selectSpecialization(post.specialName!, post.specialId!);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final addPostProvider = Provider.of<postProvider>(context);
    final catProvider = Provider.of<CategoryProvider>(context, listen: false);
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    Future<bool> submitOrder(postModel post, String specialization, File? image) async {
      if (isUpdate) {
        await myPostProvider.updatePost(post);
      } else {
        await myPostProvider.addPost(post, specialization, image);
      }
      return true;
    }

    return Scaffold(
      appBar: customAppbar(
        isUpdate ? "Update Post" : "Add Post",
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
                height: 640 * SizeConfig.verticalBlock,
                child: ListView(
                  children: [
                    Padding(
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
                    Padding(
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
                    incrementDecrementButtons("price", "0.00", addPostProvider.price,
                        "ًWrite an estimated price that suits you for the whole."),
                    incrementDecrementButtons("Duration", "0.00", addPostProvider.duration,
                        "Write an estimated time you can wait for the order to be completed."),
                    incrementDecrementButtons("Quantity", "0.00", addPostProvider.quantity,
                        "Write the number you want."),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20 * SizeConfig.horizontalBlock,
                        bottom: 10 * SizeConfig.verticalBlock,
                      ),
                      child: Text("Specializations",
                          style: TextStyle(fontSize: 20 * SizeConfig.textRatio)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16 * SizeConfig.horizontalBlock,
                        vertical: 10 * SizeConfig.verticalBlock,
                      ),
                      child: AbsorbPointer(
                        absorbing: disableImageAndSpecialization,
                        child: specializtions(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16 * SizeConfig.horizontalBlock),
                      child: Text("Upload post Image (Max 5MB, JPG, PNG) ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () => _pickImage(ImageSource.gallery),
                        child: Container(
                          margin:
                          EdgeInsets.only(top: 10 * SizeConfig.verticalBlock),
                          height: 100 * SizeConfig.horizontalBlock,
                          width: 100 * SizeConfig.horizontalBlock,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border.all(width: 1, color: SizeConfig.iconColor),
                            color: const Color(0x80E9E9E9),
                          ),
                          child: widget.image != null
                              ? Image.network(widget.image!)
                              : imagePath != null
                              ? Image.network(imagePath!)
                              : postImage == null
                              ? Icon(Icons.file_upload_outlined,
                              color: SizeConfig.iconColor,
                              size: 30 * SizeConfig.textRatio)
                              : Image.file(File(postImage!.path), fit: BoxFit.cover),
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
                  buttonName: isUpdate ? "Update Post" : "Add Post",
                  buttonColor: SizeConfig.iconColor,
                  fontColor: Colors.white,
                  onClickButton: () async {
                    if (addPostProvider.title.text.trim().isEmpty ||
                        addPostProvider.description.text.trim().isEmpty ||
                        addPostProvider.price.text.trim().isEmpty ||
                        addPostProvider.duration.text.trim().isEmpty ||
                        addPostProvider.quantity.text.trim().isEmpty ||
                        catProvider.selectedSpecializationId == null ||
                        catProvider.selectedSpecializationId!.isEmpty) {
                      showCustomPopup(context, "Missing!",
                          "Please fill in all fields and select specialization", []);
                      return;
                    }

                    setState(() => _isLoading = true);

                    final selectedSpecialization =
                    catProvider.selectedSpecializationId!;

                    try {
                      final post = postModel(
                        id: isUpdate ? args!['post'].id : null,
                        title: addPostProvider.title.text,
                        description: addPostProvider.description.text,
                        price: double.parse(addPostProvider.price.text),
                        duration: int.parse(addPostProvider.duration.text),
                        quantity: int.parse(addPostProvider.quantity.text),
                      );

                      File? finalImage = postImage;
                      if (!isUpdate && finalImage == null && widget.image != null) {
                        finalImage = await downloadImageFromUrl(widget.image!);
                      }

                      final success = await submitOrder(
                          post, selectedSpecialization, finalImage);

                      if (success && mounted) {
                        clearFields(addPostProvider);
                        Navigator.pop(context, true);
                      } else {
                        showCustomPopup(
                            context, "Post", "Failed to add post", []);
                      }
                    } catch (e) {
                      showCustomPopup(context, "Post", e.toString(), []);
                    } finally {
                      if (mounted) setState(() => _isLoading = false);
                    }
                  },
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
