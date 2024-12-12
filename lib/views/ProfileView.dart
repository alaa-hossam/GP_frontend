import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gp_frontend/widgets/customizeNavigatorProfile.dart';
import 'package:gp_frontend/widgets/customizeProfileOptions.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/BottomBar.dart';
import '../widgets/Dimensions.dart';

class Profile extends StatefulWidget {
  static String id = "ProfileScreen";

  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _image;
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF292929),
            size: SizeConfig.textRatio * 15,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Profile" , style: TextStyle(color: SizeConfig.fontColor , fontSize: SizeConfig.textRatio * 20 , fontFamily: 'Rubik',),),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.verticalBlock *30,),
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/BPM.png'),
                    backgroundColor: SizeConfig.iconColor,
                    radius: SizeConfig.horizontalBlock * 70,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      backgroundColor: SizeConfig.iconColor,
                      radius: SizeConfig.horizontalBlock * 20,
                      child: IconButton(
                        onPressed: () {
                          _pickImage(ImageSource.gallery);
                        },
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: SizeConfig.textRatio * 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.verticalBlock *10,),
              Text('Name', style: TextStyle(color: SizeConfig.fontColor , fontSize: SizeConfig.textRatio * 24, fontFamily: 'title-bold'),),
              SizedBox(height: SizeConfig.verticalBlock *10,),
              Text('Name@gmail.com', style: TextStyle(color: SizeConfig.fontColor , fontSize: SizeConfig.textRatio * 14, fontFamily: 'Roboto'),),
              SizedBox(height: SizeConfig.verticalBlock *20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomizeProfileOptions(buttonName: 'Voucher', buttonIcon: Icons.confirmation_num_outlined, iconColor: Color(0xFFDF9B3B), onClickButton: (){}),
                  SizedBox(width: SizeConfig.horizontalBlock *15,),
                  CustomizeProfileOptions(buttonName: 'Point', buttonIcon: Icons.verified_outlined, iconColor: Color(0xFF0B44ED), onClickButton: (){}),
                  SizedBox(width: SizeConfig.horizontalBlock *15,),
                  CustomizeProfileOptions(buttonName: 'Wishlist', buttonIcon: Icons.favorite, iconColor: Color(0xFFCA0003), onClickButton: (){}),
                  SizedBox(width: SizeConfig.horizontalBlock *15,),
                  CustomizeProfileOptions(buttonName: 'Gift Card', buttonIcon: Icons.wallet_giftcard_rounded, iconColor: Color(0xFF24944D), onClickButton: (){}),
                ],
              ),
              SizedBox(height: SizeConfig.verticalBlock *30,),
              customizeNavigatorProfile(buttonName: 'My Account', buttonIcon: Icons.account_circle_outlined, iconColor: SizeConfig.iconColor, onClickButton: (){}),
              SizedBox(height: SizeConfig.verticalBlock *10,),
              customizeNavigatorProfile(buttonName: 'My Orders', buttonIcon:  Icons.shopping_cart_outlined, iconColor: SizeConfig.iconColor, onClickButton: (){}),
              SizedBox(height: SizeConfig.verticalBlock *10,),
              customizeNavigatorProfile(buttonName: 'History', buttonIcon: Icons.history_outlined, iconColor: SizeConfig.iconColor, onClickButton: (){}),
              SizedBox(height: SizeConfig.verticalBlock *10,),
              customizeNavigatorProfile(buttonName: 'Setting', buttonIcon: Icons.settings_outlined, iconColor: SizeConfig.iconColor, onClickButton: (){}),
              SizedBox(height: SizeConfig.verticalBlock *10,),
              customizeNavigatorProfile(buttonName: 'Log out', buttonIcon: Icons.logout_outlined, iconColor: Color(0xFFCA0003), onClickButton: (){}),
              SizedBox(height: SizeConfig.verticalBlock *30,),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(selectedIndex: 1),
    );
  }
}
