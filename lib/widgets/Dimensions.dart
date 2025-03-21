import 'dart:math';
import 'package:flutter/widgets.dart';
class SizeConfig {
  static const double designWidth = 393;
  static const double designHeight = 852;
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double horizontalBlock;
  static late double verticalBlock;
  static late double statusBarHeight;
  static late double textRatio;
  static const Color fontColor = Color(0x803C3C3C);
  static const Color iconColor = Color(0xFF5095B0);
  static const Color secondColor = Color(0xFFB36995);


  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    statusBarHeight = _mediaQueryData.padding.top;
    horizontalBlock = (_mediaQueryData.size.width) / designWidth;
    verticalBlock = (screenHeight - statusBarHeight) / (designHeight);
    textRatio = min(verticalBlock, horizontalBlock);

  }

}