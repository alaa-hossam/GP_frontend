import 'package:flutter/material.dart';
import 'Dimensions.dart';

class CustomizeProfileOptions extends StatelessWidget {
  final String buttonName;
  final IconData buttonIcon;
  final Color iconColor;
  final Function onClickButton;

  CustomizeProfileOptions({
    required this.buttonName,
    required this.buttonIcon,
    required this.iconColor,
    required this.onClickButton
  });
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return GestureDetector(
      onTap: (){
        onClickButton();
      },
      child: Container(
        width: SizeConfig.horizontalBlock * 70,
        height: SizeConfig.verticalBlock * 70,
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                buttonIcon,
                color: iconColor,
                size: SizeConfig.textRatio * 24 ,
              ),
              SizedBox(height: SizeConfig.verticalBlock *10,),
              Text(buttonName,
                style: TextStyle(
                  color: SizeConfig.fontColor,
                  fontFamily: 'Roboto',
                  fontSize: SizeConfig.textRatio * 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
