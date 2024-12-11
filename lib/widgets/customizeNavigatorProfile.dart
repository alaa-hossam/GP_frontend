import 'package:flutter/material.dart';

import 'Dimensions.dart';

class customizeNavigatorProfile extends StatelessWidget {
  final String buttonName;
  final IconData buttonIcon;
  final Color iconColor;
  final Function onClickButton;
  customizeNavigatorProfile(
      {
        required this.buttonName,
        required this.buttonIcon,
        required this.iconColor,
        required this.onClickButton
      });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        onClickButton();
      },
      child: Container(
        width: SizeConfig.horizontalBlock * 361,
        height:SizeConfig.verticalBlock * 55,
        decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(5),
        ),
        child: ListTile(
          leading: Icon(
            buttonIcon,
            color: iconColor,
          ),
          title: Text(buttonName,
          style: TextStyle(
            color: SizeConfig.fontColor,
            fontFamily: 'Roboto',
            fontSize: SizeConfig.textRatio * 20,
          ),
        ),
          trailing: Icon(
              Icons.arrow_forward_ios,
              color: SizeConfig.fontColor,
              size: SizeConfig.textRatio * 20,
            ),
        ),
      ),
    );
  }
}
