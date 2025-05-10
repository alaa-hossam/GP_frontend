import 'package:flutter/material.dart';
import 'Dimensions.dart';

class CustomizeProfileOptions extends StatelessWidget {
  final String buttonName;
  final IconData? buttonIcon;
  final Color? iconColor;
  final VoidCallback onClickButton;
  final double? points;

  const CustomizeProfileOptions({
    Key? key,
    required this.buttonName,
    this.buttonIcon,
    this.iconColor,
    required this.onClickButton,
    this.points,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return GestureDetector(
      onTap: onClickButton,
      child: Container(
        width: SizeConfig.horizontalBlock * 70,
        height: SizeConfig.verticalBlock * 70,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (points == null && buttonIcon != null)
                Icon(
                  buttonIcon,
                  color: iconColor,
                  size: SizeConfig.textRatio * 24,
                )
              else if (points != null)
                Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.verticalBlock * 2),
                  child: Text(
                    points!.toStringAsFixed(0), // Convert double to string
                    style: TextStyle(
                      color: SizeConfig.fontColor,
                      fontFamily: 'Roboto',
                      fontSize: SizeConfig.textRatio * 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Text(
                buttonName,
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