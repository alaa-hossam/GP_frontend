import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/views/cartView.dart';
import 'package:gp_frontend/views/chatBot.dart';
import 'package:gp_frontend/views/posts.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';

import '../views/Home.dart';

class BottomBar extends StatefulWidget {
  final int currentIndex;

  const BottomBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<BottomBar> createState() =>
      _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  List<String> pages = [Home.id ,AIChat.id , posts.id , cartScreen.id];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(icon: Icons.home_outlined, index: 0),
          _buildItem(icon: Icons.android, index: 1),
          _buildItem(icon: Icons.post_add, index: 2),
          _buildItem(icon: Icons.shopping_cart_outlined, index: 3),
        ],
      ),
    );
  }

  Widget _buildItem({required IconData icon, required int index}) {
    bool isSelected = widget.currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          final String routeName = pages[index];
          final currentRoute = ModalRoute.of(context)?.settings.name;
          if (currentRoute != routeName) {
            Navigator.pushNamed(context, routeName);
          }
        },
        child: SizedBox(
          height: 60 * SizeConfig.verticalBlock,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? SizeConfig.iconColor :SizeConfig.fontColor,
                size: 24 * SizeConfig.textRatio,
              ),
              SizedBox(height: 4 * SizeConfig.verticalBlock),
              Text(
                _getLabelText(index),
                style: TextStyle(
                  fontSize: 12 * SizeConfig.textRatio,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? SizeConfig.iconColor  : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  String _getLabelText(int index) {
    switch (index) {
      case 0:
        return "home";
      case 1:
        return "AIChat";
      case 2:
        return "Posts";
      case 3:
        return "Cart";
      default:
        return '';
    }
  }
}
