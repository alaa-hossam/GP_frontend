import 'package:flutter/material.dart';

import 'Dimensions.dart';

class customizeButton extends StatelessWidget {
  final String buttonName;
  final Color buttonColor;
  Color? IconColor;
  final IconData? buttonIcon;
  final Color fontColor;
  final Border? buttonBorder;
  final Function? onClickButton;
  double? width, height , textSize;
  customizeButton(
      {
        required this.buttonName,
        required this.buttonColor,
        this.buttonIcon,
        required this.fontColor,
        this.buttonBorder,
        this.onClickButton,
        this.width,
        this.height,
        this.IconColor,
        this.textSize,
      });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    width ??= SizeConfig.horizontalBlock * 363;
    height ??= SizeConfig.horizontalBlock * 55;
    textSize ??= SizeConfig.textRatio * 20;
    IconColor ??= SizeConfig.iconColor;
    return GestureDetector(
      onTap: (){if (onClickButton != null) {
        onClickButton!();
      }},
      child: Container(
        width: width,
        height: height,
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
                color: IconColor,
                size: textSize,
              ),
            if (buttonIcon != null) SizedBox(width: 5 * SizeConfig.horizontalBlock),
            Flexible(
              child: Text(buttonName,
                style: TextStyle(
                  color: fontColor,
                  fontFamily: 'button-bold',
                  fontSize: textSize,
                ),
              ),
            ),
          ],
        ),


      ),
    );
  }
}
