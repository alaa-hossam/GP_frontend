import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/ViewModels/CategoryViewModel.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:gp_frontend/widgets/customizeTextFormField.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/customizeButton.dart';

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
  File? _profileImage;
  File? _nationalIdImage;
  List<String> selectedSpecializations = [];

  bool _isLoading = false; // To manage the loading state

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage(ImageSource source, bool isProfileImage) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
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
    // Temporary list to hold selected specializations
    List<String> tempSelectedSpecializations = [];

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
                        final isSelected = tempSelectedSpecializations.contains(specialization.name); // Check if selected

                        return CheckboxListTile(
                          title: Text(specialization.name),
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                // If checked, add to the temp list
                                if (!tempSelectedSpecializations.contains(specialization.name)) {
                                  tempSelectedSpecializations.add(specialization.name);
                                }
                              } else {
                                // If unchecked, remove from the temp list
                                tempSelectedSpecializations.remove(specialization.name);
                              }
                            });
                          },
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
                  // Update the main list with the temporary selections
                  setState(() {
                    selectedSpecializations = List.from(tempSelectedSpecializations); // Save selected specializations
                  });
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }
// Function to fetch specializations
  Future<List<dynamic>> _fetchSpecializations() async {
    await CVM.fetchSpecialization();
    return CVM.specialization; // Return the list of specializations
  }



  void _saveData() async {
    // Validate if all fields are filled
    if (_profileName.text.isEmpty ||
        BIO.text.isEmpty ||
        _profileImage == null ||
        _nationalIdImage == null ||
        selectedSpecializations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields and select at least one specialization."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Save images to files (example: save to app's local storage)
    final profileImagePath = _profileImage!.path;
    final nationalIdImagePath = _nationalIdImage!.path;

    // TODO: Save the data (e.g., send to backend or local database)
    print("Profile Name: ${_profileName.text}");
    print("BIO: ${BIO.text}");
    print("Profile Image Path: $profileImagePath");
    print("National ID Image Path: $nationalIdImagePath");
    print("Selected Specializations: $selectedSpecializations");

    // Show success message
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text("Done!")),
    // );

    // Navigate back or reset the form
    Navigator.pop(context);
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
                Color(0xFF223F4A), // Start color
                Color(0xFF5095B0), // End color
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
      body: SingleChildScrollView(
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
                    _pickImage(ImageSource.gallery, true); // Open gallery to pick profile image
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
                        ? Icon(
                      Icons.file_upload_outlined,
                        color: SizeConfig.iconColor,
                        size: 30 * SizeConfig.textRatio
                    )
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
              SizedBox(height: 24 * SizeConfig.verticalBlock), // Add spacing

              // Profile Name Field
              MyTextFormField(
                controller: _profileName,
                labelText: "Profile Name",
                width: 361 * SizeConfig.horizontalBlock,
                maxLines: 1, // Single-line input
              ),
              SizedBox(height: 16 * SizeConfig.verticalBlock), // Add spacing

              // BIO Field
              MyTextFormField(
                controller: BIO,
                labelText: "BIO",
                width: 361 * SizeConfig.horizontalBlock,
                maxLines: 5, // Allow multiple lines for BIO
              ),
              SizedBox(height: 16 * SizeConfig.verticalBlock), // Add spacing
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
                                right: 8 * SizeConfig.horizontalBlock,),
                              child: customizeButton(
                                buttonName: specialization,
                                buttonColor: Color(0xFF5095B0),
                                fontColor: Color(0xFFFFFFFF),
                                textSize: 14 * SizeConfig.textRatio,
                                width: 60 * SizeConfig.horizontalBlock,
                                height: 25 * SizeConfig.verticalBlock,
                              ),
                            );
                          },
                        ),
                      ),
                    // Add Button
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
              SizedBox(height: 16 * SizeConfig.verticalBlock), // Add spacing

              // National ID Section
              Text(
                "National ID",
                style: TextStyle(
                  fontSize: 20 * SizeConfig.textRatio,
                  fontFamily: "Roboto",
                ),
              ),
              SizedBox(height: 8 * SizeConfig.verticalBlock), // Add spacing
              GestureDetector(
                onTap: () {
                  _pickImage(ImageSource.gallery, false); // Open gallery to pick national ID image
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
                      ? Icon(
                      Icons.file_upload_outlined,
                      color: SizeConfig.iconColor,
                      size: 30 * SizeConfig.textRatio
                  )
                      : Image.file(
                    File(_nationalIdImage!.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 24 * SizeConfig.verticalBlock), // Add spacing

              // Finish Button
              Center(
                child: customizeButton(
                  buttonName: 'Finish',
                  buttonColor: Color(0xFF5095B0),
                  fontColor: const Color(0xFFF5F5F5),
                  width: 200 * SizeConfig.horizontalBlock,
                  height: 50 * SizeConfig.verticalBlock,
                  onClickButton: _saveData,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}