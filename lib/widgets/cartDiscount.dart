import 'package:flutter/material.dart';

import 'Dimensions.dart';
import 'customizeTextFormField.dart';

class VoucherInput extends StatelessWidget {
  final TextEditingController controller;
  final String? selectedOption;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final ValueChanged<dynamic?> onTextChanged;

  const VoucherInput({
    Key? key,
    required this.controller,
    required this.selectedOption,
    required this.options,
    required this.onChanged,
    required this.onTextChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: MyTextFormField(controller: controller, hintName: "Add Voucher" , onChanged: onTextChanged,),
        ),
        Positioned(
          right: 25,
          top: 15,
          child: Container(
            width: 120 * SizeConfig.horizontalBlock,
            height: 31 * SizeConfig.verticalBlock,
            decoration: BoxDecoration(
              color: SizeConfig.secondColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: SizeConfig.secondColor, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButton<String>(
              value: selectedOption,
              onChanged: onChanged,
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              iconEnabledColor: Colors.white,
              isExpanded: true,
              underline: Container(),
              icon: null,
              dropdownColor: SizeConfig.secondColor,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}