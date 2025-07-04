import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Dimensions.dart';

class OrdersAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int index;
  final void Function(int) onTabSelected;

  OrdersAppBar({super.key, required this.index, required this.onTabSelected});

  @override
  Size get preferredSize => Size.fromHeight(122 * SizeConfig.verticalBlock);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AppBar(
          toolbarHeight: preferredSize.height,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
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
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          title: Text(
            "My Orders",
            style: GoogleFonts.rubik(
              color: Colors.white,
              fontSize: 20 * SizeConfig.textRatio,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Tabs
        Positioned(
          bottom: -15 * SizeConfig.verticalBlock,
          left: 30 * SizeConfig.horizontalBlock,
          child: appBarContainer("Active", index, 0, onTabSelected),
        ),
        Positioned(
          bottom: -15 * SizeConfig.verticalBlock,
          left: 150 * SizeConfig.horizontalBlock,
          child: appBarContainer("Complete", index, 1, onTabSelected),
        ),
        Positioned(
          bottom: -15 * SizeConfig.verticalBlock,
          left: 270 * SizeConfig.horizontalBlock,
          child: appBarContainer("Cancelled", index, 2, onTabSelected),
        ),
      ],
    );
  }
}

Widget appBarContainer(String title, int selectedIndex, int currentIndex, void Function(int) onTap) {
  return GestureDetector(
    onTap: () => onTap(currentIndex),
    child: Container(
      height: 40 * SizeConfig.verticalBlock,
      width: 100 * SizeConfig.horizontalBlock,
      decoration: BoxDecoration(
        color: selectedIndex == currentIndex ? SizeConfig.secondColor : Colors.white,
        borderRadius: BorderRadius.circular(12 * SizeConfig.verticalBlock),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          color: selectedIndex == currentIndex ? Colors.white : SizeConfig.iconColor,
          fontSize: 14 * SizeConfig.textRatio,
        ),
      ),
    ),
  );
}
