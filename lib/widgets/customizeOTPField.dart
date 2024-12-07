import 'package:flutter/material.dart';
import 'Dimensions.dart';

class Customizeotpfield extends StatelessWidget {

  final bool enable;

  Customizeotpfield({

    this.enable = true,

  });
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      width: SizeConfig.horizontalBlock * 50,
      height: SizeConfig.verticalBlock * 60,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter all numbers';
          }
          return null;
        },
        enabled: enable,
        decoration: const InputDecoration(
          enabledBorder:  OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF5095B0)),
          ),
          focusedBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),

          fillColor:  Color(0xFFF5F5F5),
          filled: true,
        ),

      ),
    );
  }
}
