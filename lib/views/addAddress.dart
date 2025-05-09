import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/AddressModel.dart';
import 'package:gp_frontend/Providers/AddressProvider.dart';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:gp_frontend/widgets/messages.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../widgets/AppBar.dart';
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

        Navigator.pop(context, true);

      } catch (e) {
        showCustomPopup(context, "Address","${e}", []);

      }
    }
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: customAppbar("add New Address" ,
        leading:IconButton(onPressed: (){Navigator.pop(context);},
            icon: Icon(Icons.arrow_back_ios_new , color: Colors.white,)),),
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