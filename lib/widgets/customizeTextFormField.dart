import 'package:flutter/material.dart';
import 'Dimensions.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintName; // Optional hint text
  final String? labelText , initialValue; // New label text
  final IconData? icon; // Optional icon
  final Widget? suffixIcon;
  final bool isObscureText, enable;
  final bool autofocus;
  double? width, height;
  final FocusNode? focusNode;
  final ValueChanged<dynamic>? onChanged;
  final Future<void> Function(BuildContext)? onClickFunction;
  final TextInputType? type;
  final int? maxLines;
  Color? fillColor;
  final int? maxLength;
  final TextStyle? hintStyle;
  final FormFieldValidator<String>? validator;
  Key? myKey;

  MyTextFormField({
    this.controller,
    this.hintName,
    this.labelText,
    this.icon,
    this.isObscureText = false,
    this.enable = true,
    this.autofocus = false,
    this.onClickFunction,
    this.suffixIcon,
    this.width,
    this.height,
    this.focusNode,
    this.onChanged,
    this.type,
    this.maxLines,
    this.fillColor,
    this.maxLength,
    this.validator,
    this.hintStyle,
    this.initialValue,
    this.myKey
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    width ??= SizeConfig.horizontalBlock * 363;
    fillColor ??= const Color(0x80E9E9E9);

    return Container(
      width: width,
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (labelText != null) // Display label if provided
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  labelText!,
                  style: TextStyle(
                    fontSize: 20 * SizeConfig.textRatio,
                    fontFamily: "Roboto",
                  ),
                ),
              ),
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: height ?? 50, // Set a minimum height
              ),
              child: TextFormField(
                key: myKey,
                controller: controller,
                obscureText: isObscureText,
                keyboardType: type,
                maxLines: maxLines, // Allow unlimited lines if maxLines is null
                minLines: 1, // Set a minimum number of lines
                maxLength: maxLength,
                initialValue: initialValue,
                validator: validator ?? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ${labelText ?? hintName ?? "this field"}'; // Use labelText or hintName for validation message
                  } else if (hintName == 'Password' && value.length < 8) {
                    return 'Password should be at least 8 characters';
                  } else if (!_emailRegex.hasMatch(value) && hintName == 'Email') {
                    return 'Email address is not valid\n It should be an Email structure';
                  } else if (hintName == 'Birth Date') {
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
                autofocus: autofocus,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5095B0)),
                  ),
                  prefixIcon: icon != null
                      ? Icon(
                    icon,
                    size: SizeConfig.textRatio * 25,
                    color: const Color(0xFF5095B0),
                  )
                      : null, // Set null if no icon is provided
                  hintText: hintName, // Optional hint text
                  hintStyle: hintStyle == null ? TextStyle(
                    color: SizeConfig.fontColor,
                    fontSize: SizeConfig.textRatio * 20,
                    fontFamily: 'Roboto',
                  ) : hintStyle,
                  fillColor: fillColor,
                  filled: true,
                  suffixIcon: suffixIcon,
                  counterText: '', // Hide the default character counter
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15, // Adjust vertical padding
                    horizontal: 10, // Adjust horizontal padding
                  ),
                ),
                onTap: () async {
                  if (onClickFunction != null) {
                    await onClickFunction!(context);
                  }
                },
                focusNode: focusNode,
                onChanged: onChanged,

              ),
            ),
          ],
        ),
      ),
    );
  }

  // Email regex for validation
  RegExp get _emailRegex => RegExp(r'^\S+@gmail.com');
}