import 'package:flutter/material.dart';
import 'Dimensions.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintName; // Optional hint text
  final String? labelText; // New label text
  final IconData? icon; // Optional icon
  final Widget? suffixIcon;
  final bool isObscureText, enable;
  final bool autofocus;
  double? width, height;
  final FocusNode? focusNode;
  final ValueChanged<dynamic>? onChanged;
  final Future<void> Function(BuildContext)? onClickFunction;
  RegExp get _emailRegex => RegExp(r'^\S+@gmail.com');
  TextInputType? type;
  int? maxLines;

  MyTextFormField({
    required this.controller,
    this.hintName,
    this.labelText, // New label text
    this.icon, // Optional icon
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
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    width ??= SizeConfig.horizontalBlock * 363;

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
            TextFormField(
              controller: controller,
              obscureText: isObscureText,
              keyboardType: type,
              maxLines: maxLines ?? 1, // Allow multiple lines if maxLines is provided
              minLines: 1, // Set a minimum number of lines
              validator: (value) {
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
                  await onClickFunction!(context);
                }
              },
              focusNode: focusNode,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}