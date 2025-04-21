import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/AddressModel.dart';
import 'package:gp_frontend/Providers/AddressProvider.dart';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../widgets/customizeButton.dart';
import '../widgets/customizeTextFormField.dart';
import '../widgets/Dimensions.dart';

class addAddress extends StatefulWidget {
  static String id = "addAddress";
  const addAddress({super.key});

  @override
  State<addAddress> createState() => _addAddressState();
}

class _addAddressState extends State<addAddress> {
  final _formKey = GlobalKey<FormState>();
  List<String> labels = [
    "Address Owner",
    "City",
    "State",
    "Street Name",
    "Building Number",
    "Floor Number",
    "Flat Number",
    "Post Code",
    "Phone Number"
  ];
  late List<TextEditingController> controllers;
  late List<String?> errors;
  late AddressProvider myAddressProvider;

  // Add a controller for the "Primary Address" dropdown
  String? _isPrimary = "No"; // Default value

  @override
  void initState() {
    super.initState();
    controllers = List.generate(labels.length, (_) => TextEditingController());
    errors = List.generate(labels.length, (_) => null);
    myAddressProvider = Provider.of<AddressProvider>(context, listen: false);
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> validateFields() async {
    setState(() {
      for (int i = 0; i < labels.length; i++) {
        final value = controllers[i].text.trim();
        if (value.isEmpty) {
          errors[i] = 'Please enter ${labels[i]}';
        } else {
          errors[i] = null;
        }
      }
    });

    // Check if there are any validation errors
    if (!errors.any((e) => e != null)) {
      final address = AddressModel(
         controllers[0].text.trim(),
         controllers[1].text.trim(),
         controllers[2].text.trim(),
         controllers[3].text.trim(),
        BuildingNum: controllers[4].text.trim(),
        FloorNum: controllers[5].text.trim(),
        FlatNum: controllers[6].text.trim(),
        PostalCode: controllers[7].text.trim(),
        PhoneNumber: controllers[8].text.trim(),
        isPrimary: _isPrimary == "Yes",
      );

      try {
        await myAddressProvider.addAddress(address);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Address added successfully!")),
        );

        // Navigate back to the previous screen
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add address: $e")),
        );
      }
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
        title: Text(
          'Add New Address',
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
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0 * SizeConfig.verticalBlock),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(labels.length, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyTextFormField(
                          controller: controllers[index],
                          labelText: labels[index],
                          width: 359 * SizeConfig.horizontalBlock,
                          height: 44 * SizeConfig.verticalBlock,
                          borderColor: SizeConfig.iconColor,
                          borderRadius: 5 * SizeConfig.horizontalBlock,
                          validator: (_) => null,
                        ),
                        if (errors[index] != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, top: 3.0),
                            child: Text(
                              errors[index]!,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14 * SizeConfig.textRatio,
                              ),
                            ),
                          ),
                        SizedBox(height: 10 * SizeConfig.verticalBlock),
                      ],
                    );
                  }),
                ),
              ),
              // Add the "Primary Address" dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Is this your primary address?",
                    style: GoogleFonts.rubik(
                      fontSize: 16 * SizeConfig.textRatio,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: _isPrimary,
                    items: ["Yes", "No"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _isPrimary = newValue;
                      });
                    },
                    isExpanded: true,
                    underline: Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10 * SizeConfig.verticalBlock),
                ],
              ),
              SizedBox(height: 10 * SizeConfig.verticalBlock),
              customizeButton(
                fontColor: Colors.white,
                buttonName: "Add",
                buttonColor: SizeConfig.iconColor,
                height: 50 * SizeConfig.verticalBlock,
                width: 370 * SizeConfig.horizontalBlock,
                onClickButton: validateFields,
              ),
            ],
          ),
        ),
      ),
    );
  }
}