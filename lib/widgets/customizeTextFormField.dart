import 'package:flutter/material.dart';
import 'Dimensions.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintName;
  final IconData? icon;
  final Widget? suffixIcon;
  final bool isObscureText, enable;
  final bool autofocus; // Add autofocus parameter
  double? width, height;
  final FocusNode? focusNode; // Make FocusNode nullable
  final ValueChanged<dynamic>? onChanged;
  final Future<void> Function(BuildContext)? onClickFunction; // Nullable function
  RegExp get _emailRegex => RegExp(r'^\S+@gmail.com');
  TextInputType? type;

  MyTextFormField({
    required this.controller,
    this.hintName,
    this.icon,
    this.isObscureText = false,
    this.enable = true,
    this.autofocus = false, // Default to false
    this.onClickFunction,
    this.suffixIcon,
    this.width,
    this.height,
    this.focusNode, // Nullable FocusNode
    this.onChanged,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    width ??= SizeConfig.horizontalBlock * 363;
    height ??= SizeConfig.verticalBlock * 55;

    return Container(
      width: width,
      height: height,
      child: TextFormField(
        controller: controller,
        obscureText: isObscureText,
        keyboardType:type,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $hintName';
          } else if (hintName == 'Password' && value.length < 8) {
            return 'Password should be at least 8 characters';
          } else if (!_emailRegex.hasMatch(value) && hintName == 'Email') {
            return 'Email address is not valid\n It should be an Email structure';
          }else if (hintName == 'Birth Date') {
            DateTime? parsedDate = DateTime.tryParse(value);
            if (parsedDate == null) {
              return 'Invalid date format';
            }
            if (parsedDate.year >= 2017) {
              return 'Birth date must be before 2017';
            }
          }
          return null;
        },
        enabled: enable,
        autofocus: autofocus, // Pass the autofocus parameter to TextFormField
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Color(0xFF5095B0)),
          ),
          prefixIcon: icon != null
              ? Icon(
            icon,
            size: SizeConfig.textRatio * 25,
            color: const Color(0xFF5095B0),
          )
              : null, // Set null if no icon is provided
          hintText: hintName,
          hintStyle: TextStyle(
            color: SizeConfig.fontColor,
            fontSize: SizeConfig.textRatio * 20,
            fontFamily: 'Roboto',
          ),
          fillColor: const Color(0x80E9E9E9),
          filled: true,
          suffixIcon: suffixIcon,
        ),
        onTap: () async {
          if (onClickFunction != null) {
            await onClickFunction!(context); // Pass the context to the callback
          }
        },
        focusNode: focusNode, // Use the nullable FocusNode
        onChanged: onChanged,
      ),
    );
  }
}