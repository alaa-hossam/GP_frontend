import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gp_frontend/views/historyView.dart';
import 'package:gp_frontend/views/voucherView.dart';
import 'package:gp_frontend/views/wishListView.dart';
import 'package:gp_frontend/widgets/customizeNavigatorProfile.dart';
import 'package:gp_frontend/widgets/customizeProfileOptions.dart';
import 'package:image_picker/image_picker.dart';
import '../Models/CustomerModel.dart';
import '../widgets/BottomBar.dart';
import '../widgets/Dimensions.dart';
import 'chooseAddress.dart';
import 'logInView.dart';

class Profile extends StatefulWidget {
  static String id = "ProfileScreen";
  final CustomerModel customer;

  const Profile(this.customer, {super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _image;
  late CustomerModel _customer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _customer = widget.customer;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
        });
        // TODO: Upload image to server
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 310 * SizeConfig.verticalBlock,
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
        leading: null,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: SizeConfig.textRatio * 15),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  'My Profile',
                  style: TextStyle(
                    fontFamily: "Rubik",
                    fontSize: 20 * SizeConfig.textRatio,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: SizeConfig.horizontalBlock * 85,
                  height: SizeConfig.verticalBlock * 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_events_outlined,
                          color: Color(0xFF0B44ED),
                          size: 20 * SizeConfig.textRatio),
                      const SizedBox(width: 6),
                      Text(
                        _customer.points.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 19 * SizeConfig.textRatio,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'points',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10 * SizeConfig.textRatio,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: SizeConfig.iconColor,
                    radius: SizeConfig.horizontalBlock * 70,
                    child: CircleAvatar(
                      radius: SizeConfig.horizontalBlock * 67,
                      backgroundColor: Colors.white,
                      child: _customer.profileImage != null
                          ? ClipOval(
                        child: Image.network(
                          _customer.profileImage!,
                          width: SizeConfig.horizontalBlock * 134,
                          height: SizeConfig.horizontalBlock * 134,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Icon(
                        Icons.person,
                        size: SizeConfig.horizontalBlock * 60,
                        color: SizeConfig.iconColor,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.0),
                      ),
                      child: CircleAvatar(
                        backgroundColor: SizeConfig.iconColor,
                        radius: SizeConfig.horizontalBlock * 20,
                        child: IconButton(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                            size: SizeConfig.textRatio * 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Text(
                _customer.name!,
                style: TextStyle(
                  fontFamily: "Rubik",
                  fontSize: 24 * SizeConfig.textRatio,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                _customer.email!,
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 16 * SizeConfig.textRatio,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: SizeConfig.verticalBlock * 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomizeProfileOptions(
                    buttonName: 'Voucher',
                    buttonIcon: Icons.confirmation_num_outlined,
                    iconColor: const Color(0xFFDF9B3B),
                    onClickButton: () =>
                        Navigator.pushNamed(context, voucherView.id),
                  ),
                  SizedBox(width: SizeConfig.horizontalBlock * 15),
                  CustomizeProfileOptions(
                    buttonName: 'Wishlist',
                    buttonIcon: Icons.favorite,
                    iconColor: const Color(0xFFCA0003),
                    onClickButton: () =>
                        Navigator.pushNamed(context, wishListView.id),
                  ),
                  SizedBox(width: SizeConfig.horizontalBlock * 15),
                  CustomizeProfileOptions(
                    buttonName: 'Gift Card',
                    buttonIcon: Icons.wallet_giftcard_rounded,
                    iconColor: const Color(0xFF24944D),
                    onClickButton: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.verticalBlock * 20),
            ..._buildProfileOptions(),
            SizedBox(height: SizeConfig.verticalBlock * 10),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(currentIndex: 2),
    );
  }

  List<Widget> _buildProfileOptions() {
    return [
      customizeNavigatorProfile(
        buttonName: 'My Orders',
        buttonIcon: Icons.shopping_cart_outlined,
        iconColor: SizeConfig.iconColor,
        onClickButton: () {},
      ),
      SizedBox(height: SizeConfig.verticalBlock * 10),
      customizeNavigatorProfile(
        buttonName: 'History',
        buttonIcon: Icons.history_outlined,
        iconColor: SizeConfig.iconColor,
        onClickButton: () =>
            Navigator.pushNamed(context, HistoryProducts.id),
      ),
      SizedBox(height: SizeConfig.verticalBlock * 10),
      customizeNavigatorProfile(
        buttonName: 'My Addresses',
        buttonIcon: Icons.location_on_outlined,
        iconColor: SizeConfig.iconColor,
        onClickButton: () =>
            Navigator.pushNamed(context, chooseAddress.id),
      ),
      SizedBox(height: SizeConfig.verticalBlock * 10),
      customizeNavigatorProfile(
        buttonName: 'Setting',
        buttonIcon: Icons.settings_outlined,
        iconColor: SizeConfig.iconColor,
        onClickButton: () {},
      ),
      SizedBox(height: SizeConfig.verticalBlock * 10),
      customizeNavigatorProfile(
        buttonName: 'Log out',
        buttonIcon: Icons.logout_outlined,
        iconColor: const Color(0xFFCA0003),
        onClickButton: () {
          Navigator.popUntil(context, ModalRoute.withName(logIn.id));
        },
      ),
    ];
  }
}
