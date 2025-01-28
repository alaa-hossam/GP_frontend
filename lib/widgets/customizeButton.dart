import 'package:flutter/material.dart';

import 'Dimensions.dart';

class customizeButton extends StatelessWidget {
  final String buttonName;
  final Color buttonColor;
  final IconData? buttonIcon;
  final Color fontColor;
  final Border? buttonBorder;
  final Function? onClickButton;
  customizeButton(
      {
        required this.buttonName,
        required this.buttonColor,
        this.buttonIcon,
        required this.fontColor,
        this.buttonBorder,
        this.onClickButton
      });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: (){if (onClickButton != null) {
        onClickButton!();
      }},
      child: Container(
        width: SizeConfig.horizontalBlock * 363,
        height:SizeConfig.verticalBlock * 55,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(5),
          border: buttonBorder
        ),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (buttonIcon != null)
              Icon(
                buttonIcon,
                color: SizeConfig.iconColor,
                size: 20 * SizeConfig.textRatio,
              ),
            if (buttonIcon != null) SizedBox(width: 10),
            SizedBox(width: 10,),
            Text(buttonName,
              style: TextStyle(
                color: fontColor,
                fontFamily: 'button-bold',
                fontSize: SizeConfig.textRatio * 20,
              ),
            ),
          ],
        ),


      ),
    );
  }
}
