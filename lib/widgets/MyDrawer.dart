import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/Models/CustomerModel.dart';
import 'package:gp_frontend/views/showOrders.dart';
import '../CommomnFunctions/ProfileData.dart';
import '../SqfliteCodes/Token.dart';
import '../ViewModels/customerViewModel.dart';
import '../views/AddAdvertisement.dart';
import '../views/HandcrafterRequest.dart';
import '../views/RecommendGiftView.dart';
import '../views/browseProducts.dart';
import '../views/eventsView.dart';
import '../views/historyView.dart';
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
  final cvm = customerViewModel();
  CustomerModel _customer = CustomerModel();
  bool _isLoading = true;
  final token = Token();
  late String _role;
  @override
  void initState() {
    super.initState();
    _loadData(); // Load everything at once
  }

  Future<void> _loadData() async {
    try {
      final customer = await cvm.fetchUserProfile();
      final role = await token.getRole() ?? "";
      setState(() {
        _customer = customer!;
        _role = role!;
        _isLoading = false;
      });
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error loading profile")),
      );
    }
  }

  Widget _buildDrawerHeader() {

    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                child: CircleAvatar(
                  backgroundColor: SizeConfig.iconColor,
                  radius: SizeConfig.horizontalBlock * 50,
                  child: CircleAvatar(
                    radius: SizeConfig.horizontalBlock * 47,
                    backgroundColor: Colors.white,
                    child: _customer?.profileImage != null
                        ? ClipOval(
                      child: Image.network(
                        _customer!.profileImage!,
                        width: SizeConfig.horizontalBlock * 134,
                        height: SizeConfig.horizontalBlock * 134,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Center(
                      child: Icon(
                        Icons.person,
                        size: SizeConfig.horizontalBlock * 60,
                        color: SizeConfig.iconColor,
                      ),
                    ),
                  ),
                ),
              ),
              Text(_customer.name!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text(_customer.email!, style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    if (_isLoading) {
      return Drawer(
        child: Center(child: CircularProgressIndicator()),
      );
    }

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
                        SizeConfig.iconColor, () async {
                      loadProfileByRole(
                        context: context,
                        onCustomerLoaded: (customer) {
                          print("Customer loaded: ${customer.name}");
                        },
                        onCrafterLoaded: (crafter) {
                          print("Crafter loaded: ${crafter.name}");
                        },
                      );
                    }),
                    sideButton("My orders", Icons.shopping_cart_outlined,
                        SizeConfig.iconColor, () {
                      Navigator.pushNamed(context, showOrders.id);
                    }),
                    sideButton(
                        "History", Icons.history_outlined, SizeConfig.iconColor,
                        () {
                      Navigator.pushNamed(context, HistoryProducts.id);
                    }),
                    sideButton("My posts", Icons.post_add, SizeConfig.iconColor,
                        () {
                      Navigator.pushNamed(context, posts.id, arguments: 0);
                    }),
                    sideButton("Compare Products", Icons.compare_outlined,
                        SizeConfig.iconColor, () {
                      Navigator.pushNamed(context, browseProducts.id,
                          arguments: {"showCompare": true});
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
                    if (_role == 'Client')
                      sideButton("Join as Handcrafter",
                          Icons.shopping_bag_outlined, SizeConfig.iconColor, () {
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
  }
}
