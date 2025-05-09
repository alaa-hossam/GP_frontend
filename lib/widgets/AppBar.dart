import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../views/ProfileView.dart';
import 'Dimensions.dart';

class customAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<IconButton>? actions;
  final IconButton? leading;

  // Constructor
  customAppbar(this.title, {this.actions, this.leading});

  @override
  Size get preferredSize => Size.fromHeight(85 * SizeConfig.verticalBlock);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      toolbarHeight: preferredSize.height,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF223F4A), Color(0xFF5095B0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      leading: leading,
      title: Text(
        title,
        style: GoogleFonts.rubik(
          color: Colors.white,
          fontSize: 20 * SizeConfig.textRatio,
        ),
      ),
      actions: actions,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    );
  }
}