import 'package:flutter/material.dart';

import 'Dimensions.dart';

class customizeButton extends StatelessWidget {
  final String buttonName;
  customizeButton(
      {
        required this.buttonName,
      });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: (){},
      child: Container(
        width: SizeConfig.horizontalBlock * 363,
        height:SizeConfig.verticalBlock * 55,
        decoration: BoxDecoration(
          color: Color(0xFF5095B0),
          borderRadius: BorderRadius.circular(5),
        ),
        child:  Center(
          child: Text(buttonName,
            style: TextStyle(
              color: Color(0xFFF5F5F5),
              fontFamily: 'button-bold',
              fontSize: SizeConfig.textRatio * 20,
            ),
          ),
        ),
      ),
    );
  }
}
