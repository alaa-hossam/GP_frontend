import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../CommomnFunctions/ProfileData.dart';
import '../views/cartView.dart';
import 'Dimensions.dart';

class HomeBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(60 * SizeConfig.verticalBlock);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      actions: [
        // IconButton(
        //   onPressed: () async {
        //     // await Cart().deleteDatabaseFile();
        //     // String id = await getId();
        //     // Widget screen = ChatScreen(
        //     //   currentUserId: id,
        //     //   otherUserId: "bf6c1277-7f7f-41c2-993b-d5a4c3a48d1a",
        //     // );
        //     //
        //     // Navigator.push(
        //     //   context,
        //     //   MaterialPageRoute(builder: (context) => screen),
        //     // );
        //   },
        //   icon: Icon(Icons.notifications_none, size: 24),
        // ),
        IconButton(
          onPressed: () => Navigator.pushNamed(context, cartScreen.id),
          icon: Icon(Icons.shopping_cart_outlined, size: 24),
        ),
        IconButton(
          onPressed: () async {
            loadProfileByRole(
              context: context,
              onCustomerLoaded: (customer) {
                print("Customer loaded: ${customer.name}");
              },
              onCrafterLoaded: (crafter) {
                print("Crafter loaded: ${crafter.name}");
              },
            );
          },
          icon: Icon(Icons.account_circle_outlined, size: 24),
        ),
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/Frame 36920.png", width: 40, height: 40),
          Text(
            "SAN3A",
            style: TextStyle(
              color: Color(0xFF073477),
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontFamily: 'Poppins',
              fontSize: 24,
            ),
          ),
        ],
      ),
    );

  }
}