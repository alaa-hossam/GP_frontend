import 'package:flutter/material.dart';
import 'Dimensions.dart';

class myTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintName;
  final IconData icon;
  final bool isObscureText , enable;
  RegExp get _emailRegex => RegExp(r'^\S+@stud.fci-cu.edu.eg');
  myTextFormField(
      {required this.controller,
        required this.hintName,
        required this.icon,
        this.isObscureText = false,
        this.enable=true,
      });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // print(SizeConfig.horizontalBlock * 363);

    return Container(
      padding:const EdgeInsets.symmetric(horizontal: 20.0),
      width: SizeConfig.horizontalBlock * 363,
      height:SizeConfig.verticalBlock * 55,
      child: TextFormField(
        controller: controller,
        obscureText: isObscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            if(hintName == 'studentID@stud.fci-cu.edu.eg'){
              return 'Please enter your E-mail';
            }
            return 'Please enter $hintName';
          } else if(hintName == 'password' && value.length<8){
            return 'Password should be at least 8 characters';
          }else if (!_emailRegex.hasMatch(value) && hintName == 'studentID@stud.fci-cu.edu.eg'){
            return 'Email address is not valid\n It should be FCI Email structure';
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
          prefixIcon: Icon(icon, size: SizeConfig.textRatio * 20, color: Color(0xFF5095B0),),
          hintText: hintName,
          hintStyle: TextStyle(
              color: Color(0xFF3C3C3C),
              fontSize:SizeConfig.textRatio * 20,
              fontFamily: 'Roboto'
          ),
          labelText: hintName,
          fillColor: Color(0xFFF5F5F5),
          filled: true,
        ),
      ),
    );
  }
}