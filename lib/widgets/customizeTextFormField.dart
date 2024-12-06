import 'package:flutter/material.dart';
import 'Dimensions.dart';

class myTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintName;
  final IconData icon;
  final Widget? suffixIcon;
  final bool isObscureText , enable;
  RegExp get _emailRegex => RegExp(r'^\S+@gmail.com');
  myTextFormField(
      {required this.controller,
        required this.hintName,
        required this.icon,
        this.isObscureText = false,
        this.enable=true,
        this.suffixIcon,
      });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      width: SizeConfig.horizontalBlock * 363,
      height:SizeConfig.verticalBlock * 55,
      child: TextFormField(
        controller: controller,
        obscureText: isObscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $hintName';
          } else if(hintName == 'password' && value.length<8){
            return 'Password should be at least 8 characters';
          }else if (!_emailRegex.hasMatch(value) && hintName == 'Email'){
            return 'Email address is not valid\n It should be Email structure';
          }
          return null;
        },
        enabled: enable,
        decoration: InputDecoration(
          enabledBorder:const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder:const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Colors.blue),
          ),
          prefixIcon: Icon(icon, size: SizeConfig.textRatio * 25, color: Color(0xFF5095B0),),
          hintText: hintName,
          hintStyle: TextStyle(

              color: Color(0x803C3C3C),
              fontSize:SizeConfig.textRatio * 20,
              fontFamily: 'Roboto'
          ),
          fillColor: Color(0xFFF5F5F5),
          filled: true,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}