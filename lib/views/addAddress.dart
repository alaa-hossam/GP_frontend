import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/customizeButton.dart';
import '../widgets/customizeTextFormField.dart';
import '../widgets/Dimensions.dart';
import 'checkOut.dart';

class addAddress extends StatefulWidget {
  static String id = "addAddress";
  const addAddress({super.key});

  @override
  State<addAddress> createState() => _addAddressState();
}

class _addAddressState extends State<addAddress> {
  final _formKey = GlobalKey<FormState>();
  List<String> labels = [
    "Address Owner", "City", "State", "Street name",
    "Building Number", "Floor Number", "Flat number",
    "Post Code", "Phone Number"
  ];
  late List<TextEditingController> controllers;
  late List<String?> errors;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(labels.length, (_) => TextEditingController());
    errors = List.generate(labels.length, (_) => null);
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void validateFields() {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Address added successfully!")),
      );

     Navigator.pop(context);

      // Pop with data

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
                          borderwidth: 1 * SizeConfig.horizontalBlock,
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
