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
  double? width, height , borderwidth , borderRadius;
  final FocusNode? focusNode;
  final ValueChanged<dynamic>? onChanged;
  final Future<void> Function(BuildContext)? onClickFunction;
  final TextInputType? type;
  final int? maxLines;
  Color? fillColor , borderColor;
  final int? maxLength;
  final TextStyle? hintStyle , labelStyle;
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
    this.myKey,
    this.borderColor,
    this.borderwidth,
    this.borderRadius,
    this.labelStyle
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
                  style: labelStyle == null ?TextStyle(
                    fontSize: 20 * SizeConfig.textRatio,
                    fontFamily: "Roboto",
                  ): labelStyle,
                ),
              ),
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: height ?? 50,
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: borderwidth ?? 0 , color: borderColor ?? Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 0))
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
                      return 'Please enter ${labelText ?? hintName ?? "this field"}';
                    } else if (hintName == 'Password' || labelText == 'Password') {
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      if (!_passwordRegex.hasMatch(value)) {
                        return 'Password must contain:\n- At least one uppercase letter\n- One lowercase letter\n- One number\n- One special character';
                      }
                    } else if (hintName == 'Email' || labelText == 'Email') {
                      if (!_emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address\n(e.g., example@domain.com)';
                      }
                    } else if (hintName == 'Phone' || labelText == 'Phone') {
                      if (!_phoneRegex.hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
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
            ),
          ],
        ),
      ),
    );
  }

  // Email regex for validation
  RegExp get _emailRegex => RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$'
  );

  // Password regex pattern (at least 8 chars with uppercase, lowercase, number, and special char)
  RegExp get _passwordRegex => RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%^&*()_+{}\[\]:;"\<>,.?~\\-]).{8,}$'
  );


  RegExp get _phoneRegex => RegExp(
      r'^\+?[0-9]{11,13}$');

}