import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Dimensions.dart';

class MyDropDownMenu extends StatefulWidget {
  final List<String> dropDownItems;
  final IconData prefixIcon;
  final String hintText;
  final ValueChanged<String?>? onChanged; // Add this parameter

  MyDropDownMenu({
    required this.dropDownItems,
    required this.prefixIcon,
    required this.hintText,
    this.onChanged, // Initialize it
  });

  @override
  _MyDropDownMenuState createState() => _MyDropDownMenuState();
}

class _MyDropDownMenuState extends State<MyDropDownMenu> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.horizontalBlock * 363,
      height: SizeConfig.verticalBlock * 55,
      color: const Color(0xFFF5F5F5),      // Existing implementation
      child: DropdownButton<String>(
        underline: Container(),
        value: selectedValue,
        hint: Text(widget.hintText),
        icon: const Icon(Icons.arrow_drop_down),
        isExpanded: true,
        items: widget.dropDownItems.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(newValue); // Trigger the callback
          }
        },
      ),
    );
  }
}
