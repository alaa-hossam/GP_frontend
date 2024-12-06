import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Dimensions.dart';

class MyDropDownMenu extends StatefulWidget {
  final List<String> dropDownItems;
  final IconData prefixIcon;
  final String hintText;
  MyDropDownMenu({required this.dropDownItems, required this.prefixIcon ,required this.hintText});

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
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
      ),
      child: Row(
        children: [
          // Prefix Icon
          Icon(widget.prefixIcon, color: SizeConfig.iconColor), // Dynamically using the passed prefixIcon
          SizedBox(width: 10), // Spacing between the icon and the dropdown
          Expanded(  // To make the dropdown take the remaining space
            child: DropdownButton<String>(
              underline: Container(),
              value: selectedValue,
              hint: Text(
                widget.hintText,
                style: TextStyle(
                  color: SizeConfig.fontColor,
                  fontSize: 20 * SizeConfig.textRatio,
                ),
              ),
              icon: const Icon(Icons.arrow_drop_down), // Dropdown icon
              isExpanded: true,  // Ensures dropdown takes the full width
              items: widget.dropDownItems.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue; // Update the selected value
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
