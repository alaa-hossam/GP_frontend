import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Dimensions.dart';

class MyDropDownMenu extends StatefulWidget {
  final List<String> dropDownItems;
  final IconData prefixIcon;
  final String hintText;
  final ValueChanged<String?>? onChanged;
// Add this parameter

  MyDropDownMenu({
    required this.dropDownItems,
    required this.prefixIcon,
    required this.hintText,
    this.onChanged,

  });

  @override
  _MyDropDownMenuState createState() => _MyDropDownMenuState();
}

class _MyDropDownMenuState extends State<MyDropDownMenu> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // Ensure SizeConfig is initialized


    return Container(
      padding: EdgeInsets.only(left: 10 * SizeConfig.horizontalBlock),
      constraints: BoxConstraints(
        maxHeight: 55 * SizeConfig.verticalBlock,
      ),
      width: 363 * SizeConfig.horizontalBlock,
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: DropdownButton<String>(
          itemHeight: 55 * SizeConfig.verticalBlock,
          underline: const SizedBox(), // Removes the underline
          padding: EdgeInsets.zero, // Set padding to zero
          value: selectedValue,
          hint: Row(
            children: [
              Icon(
                widget.prefixIcon,
                size: SizeConfig.textRatio * 25,
                color: const Color(0xFF5095B0),
              ),
              SizedBox(width: 5 * SizeConfig.horizontalBlock),
              Text(
                widget.hintText,
                style: TextStyle(
                  color: SizeConfig.fontColor,
                  fontSize: SizeConfig.textRatio * 20,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
          icon: Icon(Icons.arrow_drop_down, size: 25 * SizeConfig.textRatio),
          isExpanded: true,
          items: widget.dropDownItems.map((String item) {
            return DropdownMenuItem<String>(

              value: item,
              child: Text(
                item,
                style: TextStyle(
                  fontSize: SizeConfig.textRatio * 20,
                  fontFamily: 'Roboto',
                ),
              ),
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
      ),
    );
  }
}
