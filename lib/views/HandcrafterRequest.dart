import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/ViewModels/CategoryViewModel.dart';
import 'package:gp_frontend/ViewModels/handcrafterViewModel.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:gp_frontend/widgets/customizeTextFormField.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/customizeButton.dart';
import 'Home.dart';

class HandcrafterRequest extends StatefulWidget {
  static String id = "HandcrafterRequestScreen";

  const HandcrafterRequest({super.key});

  @override
  State<HandcrafterRequest> createState() => _HandcrafterRequestState();
}

class _HandcrafterRequestState extends State<HandcrafterRequest> {
  final TextEditingController _profileName = TextEditingController();
  final TextEditingController BIO = TextEditingController();
  CategoryViewModel CVM = CategoryViewModel();
  handcrafterViewModel HVM = handcrafterViewModel();
  File? _profileImage;
  File? _nationalIdImage;
  List<String> selectedSpecializations = [];
  List<String> selectedSpecializationsID = [];

  bool _isLoading = false;

  @override
  void dispose() {
    _profileName.dispose();
    BIO.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source, bool isProfileImage) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null && mounted) {
      setState(() {
        if (isProfileImage) {
          _profileImage = File(pickedImage.path);
        } else {
          _nationalIdImage = File(pickedImage.path);
        }
      });
    }
  }

  void _openSpecializationsBottomSheet(BuildContext context) {
    List<String> tempSelectedSpecializations = [];
    List<String> tempSelectedSpecializationsID = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: 541 * SizeConfig.verticalBlock,
          width: 361 * SizeConfig.horizontalBlock,
          padding: EdgeInsets.all(16 * SizeConfig.horizontalBlock),
          child: Column(
            children: [
              Container(
                width: 56 * SizeConfig.horizontalBlock,
                height: 1 * SizeConfig.verticalBlock,
                color: SizeConfig.iconColor,
              ),
              Text(
                "Specializations",
                style: TextStyle(
                  fontSize: 24 * SizeConfig.textRatio,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _fetchSpecializations(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error fetching specializations"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("No specializations found"));
                    }

                    final specializations = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: specializations.length,
                      itemBuilder: (context, index) {
                        final specialization = specializations[index];
                        final isSelected = tempSelectedSpecializations.contains(specialization.name);
                        bool check ;

                        return CheckboxListTile(
                          title: Text(specialization.name),
                          value: isSelected, // Check if selected
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                // Checkbox is checked
                                if (!tempSelectedSpecializations.contains(specialization.name)) {
                                  tempSelectedSpecializations.add(specialization.name); // Add specialization
                                  tempSelectedSpecializationsID.add(specialization.id); // Add ID
                                }
                              } else {
                                // Checkbox is unchecked
                                tempSelectedSpecializations.remove(specialization.name); // Remove specialization
                                tempSelectedSpecializationsID.remove(specialization.id); // Remove ID
                              }
                            });
                          },
                          activeColor: Colors.green, // Change this to your desired color
                          checkColor: SizeConfig.iconColor, // Change this to your desired checkmark color
                        );
                      },
                    );
                  },
                ),
              ),
              customizeButton(
                buttonName: 'Select',
                buttonColor: Color(0xFF5095B0),
                fontColor: const Color(0xFFF5F5F5),
                onClickButton: () {
                  if (mounted) {
                    setState(() {
                      selectedSpecializations = List.from(tempSelectedSpecializations);
                      selectedSpecializationsID = List.from(tempSelectedSpecializationsID);
                    });
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<dynamic>> _fetchSpecializations() async {
    await CVM.fetchSpecialization();
    return CVM.specialization;
  }

  Future<String> _saveData() async {
    if (_profileName.text.isEmpty ||
        BIO.text.isEmpty ||
        _profileImage == null ||
        _nationalIdImage == null ||
        selectedSpecializations.isEmpty) {
      return "Please fill all fields";
    }

    try {
      return await HVM.addHandcrafter(
        profileImage: _profileImage,
        name: _profileName.text,
        BIO: BIO.text,
        nationalIdImage: _nationalIdImage,
        specializationsId: selectedSpecializationsID,
      );
    } catch (e) {
      return "An error occurred: $e";
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
          'Request',
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
                children: [
                  // Profile Photo Section
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _pickImage(ImageSource.gallery, true);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 50 * SizeConfig.verticalBlock),
                        height: 100 * SizeConfig.horizontalBlock,
                        width: 100 * SizeConfig.horizontalBlock,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(width: 1, color: SizeConfig.iconColor),
                          color: const Color(0x80E9E9E9),
                        ),
                        child: _profileImage == null
                            ? Icon(Icons.file_upload_outlined,
                            color: SizeConfig.iconColor,
                            size: 30 * SizeConfig.textRatio)
                            : Image.file(
                          File(_profileImage!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Profile Photo",
                      style: TextStyle(
                        fontSize: 20 * SizeConfig.textRatio,
                        fontFamily: "Roboto",
                      ),
                    ),
                  ),
                  SizedBox(height: 24 * SizeConfig.verticalBlock),
                  MyTextFormField(
                    controller: _profileName,
                    labelText: "Profile Name",
                    width: 361 * SizeConfig.horizontalBlock,
                    maxLines: 1,
                  ),
                  SizedBox(height: 16 * SizeConfig.verticalBlock),
                  MyTextFormField(
                    controller: BIO,
                    labelText: "BIO",
                    width: 361 * SizeConfig.horizontalBlock,
                    maxLines: 5,
                  ),
                  SizedBox(height: 16 * SizeConfig.verticalBlock),
                  Text(
                    "Specializations",
                    style: TextStyle(
                      fontSize: 20 * SizeConfig.textRatio,
                      fontFamily: "Roboto",
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10 * SizeConfig.horizontalBlock),
                    height: 60 * SizeConfig.verticalBlock,
                    width: 361 * SizeConfig.horizontalBlock,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(width: 1, color: SizeConfig.iconColor),
                      color: const Color(0x80E9E9E9),
                    ),
                    child: Row(
                      children: [
                        if (selectedSpecializations.isNotEmpty)
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: selectedSpecializations.length,
                              itemBuilder: (context, index) {
                                final specialization = selectedSpecializations[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: 8 * SizeConfig.horizontalBlock,
                                  ),
                                  child: customizeButton(
                                    buttonName: specialization,
                                    buttonColor: Color(0xFF5095B0),
                                    fontColor: Color(0xFFFFFFFF),
                                    textSize: 14 * SizeConfig.textRatio,
                                    width: _calculateButtonWidth(specialization, context),
                                    height: 25 * SizeConfig.verticalBlock,
                                  ),
                                );
                              },
                            ),
                          ),
                        customizeButton(
                          buttonColor: Color(0xFFB36995),
                          buttonName: "Add",
                          fontColor: Color(0xFFFFFFFF),
                          buttonIcon: Icons.add,
                          IconColor: Color(0xFFFFFFFF),
                          textSize: 14 * SizeConfig.textRatio,
                          width: 60 * SizeConfig.horizontalBlock,
                          height: 25 * SizeConfig.verticalBlock,
                          onClickButton: () {
                            _openSpecializationsBottomSheet(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16 * SizeConfig.verticalBlock),
                  Text(
                    "National ID",
                    style: TextStyle(
                      fontSize: 20 * SizeConfig.textRatio,
                      fontFamily: "Roboto",
                    ),
                  ),
                  SizedBox(height: 8 * SizeConfig.verticalBlock),
                  GestureDetector(
                    onTap: () {
                      _pickImage(ImageSource.gallery, false);
                    },
                    child: Container(
                      height: 60 * SizeConfig.horizontalBlock,
                      width: 361 * SizeConfig.horizontalBlock,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(width: 1, color: SizeConfig.iconColor),
                        color: const Color(0x80E9E9E9),
                      ),
                      child: _nationalIdImage == null
                          ? Icon(Icons.file_upload_outlined,
                          color: SizeConfig.iconColor,
                          size: 30 * SizeConfig.textRatio)
                          : Image.file(
                        File(_nationalIdImage!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 24 * SizeConfig.verticalBlock),
                  Center(
                    child: customizeButton(
                      buttonName: 'Finish',
                      buttonColor: Color(0xFF5095B0),
                      fontColor: const Color(0xFFF5F5F5),
                      width: 200 * SizeConfig.horizontalBlock,
                      height: 50 * SizeConfig.verticalBlock,
                      onClickButton: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        String response = await _saveData();

                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });

                          if (response == "Please fill all fields") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please fill all fields and select at least one specialization."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else if (response == "Handcrafter added successfully") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Your Request Sent successfully!")),
                            );
                            Navigator.pushReplacementNamed(context, Home.id);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(response)),
                            );
                          }
                        }
                      },
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