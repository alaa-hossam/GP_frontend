import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/views/showOrders.dart';

import '../SqfliteCodes/Token.dart';
import '../views/AddAdvertisement.dart';
import '../views/HandcrafterRequest.dart';
import '../views/MyHandcrafterProfile.dart';
import '../views/ProfileView.dart';
import '../views/RecommendGiftView.dart';
import '../views/browseProducts.dart';
import '../views/eventsView.dart';
import '../views/historyView.dart';
import '../views/joinBazar.dart';
import '../views/logInView.dart';
import '../views/posts.dart';
import 'Dimensions.dart';
import 'SideButton.dart';

class Mydrawer extends StatefulWidget {
  const Mydrawer({super.key});

  @override
  State<Mydrawer> createState() => _MydrawerState();
}

class _MydrawerState extends State<Mydrawer> {

  Widget _buildDrawerHeader() {
    return Stack(
      children: [
        Container(
          color: const Color(0xFFE9E9E9),
          height: 251 * SizeConfig.verticalBlock,
        ),
        Positioned(
          left: 15,
          bottom: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFF5095B0), width: 3),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/p1.jpg'),
                ),
              ),
              Text("my name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text("myemail@gmail.com", style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
      return Drawer(
        width: 223 * SizeConfig.horizontalBlock,
        backgroundColor: Colors.white,
        child: Stack(
          children: [
            ListView(
              children: [
                _buildDrawerHeader(),
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: Column(
                    children: [
                      sideButton("My Account", Icons.account_circle_outlined,
                          SizeConfig.iconColor, () async{
                            final token = Token();
                            final role = await token.getRole('SELECT ROLE FROM TOKENS');
                            print(role);
                            // Navigate to the appropriate profile based on the role
                            if (role == 'Handicrafter') {
                              Navigator.pushNamed(context, MyHandcrafterProfile.id);
                            } else if (role == 'Client') {
                              Navigator.pushNamed(context, Profile.id);
                            }
                          }),
                      sideButton("My orders", Icons.shopping_cart_outlined,
                          SizeConfig.iconColor, () {
                            Navigator.pushNamed(context, showOrders.id);
                          }),
                      sideButton("History", Icons.history_outlined,
                          SizeConfig.iconColor, () {
                            Navigator.pushNamed(context, HistoryProducts.id);
                          }),
                      sideButton("My posts", Icons.post_add, SizeConfig.iconColor,
                              () {
                            Navigator.pushNamed(context, posts.id);
                          }),
                      sideButton("Compare Products", Icons.compare_outlined,
                          SizeConfig.iconColor, () {
                            Navigator.pushNamed(context, browseProducts.id , arguments: {"showCompare":true});
                          }),
                      sideButton("Recommend Gifts", Icons.card_giftcard_outlined,
                          SizeConfig.iconColor, () {
                            Navigator.pushNamed(context, RecommendGift.id);
                          }),
                      sideButton("Event Reminder", Icons.event_available_outlined,
                          SizeConfig.iconColor, () {
                            Navigator.pushNamed(context, EventsView.id);
                          }),
                      sideButton("Add Advertisement", Icons.camera_roll_outlined,
                          SizeConfig.iconColor, () {
                            Navigator.pushNamed(context, Addadvertisement.id);
                          }),
                      sideButton("Join as Handcrafter", Icons.shopping_bag_outlined,
                          SizeConfig.iconColor, () {
                            Navigator.pushNamed(context, HandcrafterRequest.id);
                          }),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 10,
              bottom: 10,
              child: sideButton("Log Out", Icons.logout_outlined, Colors.red, () {
                Navigator.pushReplacementNamed(context, logIn.id);
              }),
            ),
          ],
        ),
      );

    ;
  }
}
