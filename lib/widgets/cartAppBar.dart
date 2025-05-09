import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Dimensions.dart';

class CartBar extends StatelessWidget {
  bool disabled;
  IconData? icon;
  String? step, label;


  CartBar(
      {
      this.disabled = false,
      this.icon,
      this.step,
      this.label});


  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              backgroundColor: disabled ? Color(0x503C3C3C) : SizeConfig.secondColor,
              radius: 25 * SizeConfig.verticalBlock,
            ),
            Positioned(
              top: 5 * SizeConfig.verticalBlock,
              left: 5 * SizeConfig.verticalBlock,
              child: CircleAvatar(
                backgroundColor: disabled ? Color(0x50E9E9E9) : Colors.white,
                radius: 20 * SizeConfig.verticalBlock,
              ),
            ),
            Positioned(
              top: 10 * SizeConfig.verticalBlock,
              right: 10 * SizeConfig.verticalBlock,
              child: CircleAvatar(
                backgroundColor: disabled ? Color(0x603C3C3C) : SizeConfig.secondColor,
                radius: 15 * SizeConfig.verticalBlock,
                child: Icon(icon, color: Colors.white),
              ),
            ),
          ],
        ),
        Text(step ?? "", style: GoogleFonts.roboto(fontSize: 12, color: Colors.white)),
        SizedBox(height: 5 * SizeConfig.verticalBlock),
        Text(label ?? "",
            style: GoogleFonts.roboto(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),

      ],
    );
  }
}
