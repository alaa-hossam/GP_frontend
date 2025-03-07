import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';

class sideButton extends StatelessWidget{
  String text = "";
  IconData? icon;
  Color myColor;
  final void Function() onPressedFunction; // Nullable function


  sideButton(this.text, this.icon , this.myColor, this.onPressedFunction);

  @override
  Widget build(BuildContext context){
    SizeConfig().init(context);
    return TextButton(
      onPressed:onPressedFunction,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        alignment: Alignment.centerLeft,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: myColor,
            size: 24 * SizeConfig.textRatio,
          ),
          SizedBox(
            width: 5 * SizeConfig.horizontalBlock,
          ),
          Text(
            text,
            style: TextStyle(
              color: Color(0x803C3C3C),
              fontSize: 16 * SizeConfig.textRatio,
            ),
          ),
        ],
      ),
    );

  }
}