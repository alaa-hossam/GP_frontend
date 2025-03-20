import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Providers/cartProvider.dart';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import '../SqfliteCodes/cart.dart'; 
import 'ProfileView.dart';

class cartScreen extends StatefulWidget {
  static String id = "cartScreen";
  const cartScreen({super.key});

  @override
  State<cartScreen> createState() => _cartScreenState();
}

class _cartScreenState extends State<cartScreen> {
  Token myToken = Token();
  Cart cart = Cart();
  List<dynamic> cartProducts = [];
  Map<dynamic, int> finalProductCounts = {};

  @override
  void initState() {
    super.initState();
    // Fetch cart products when the screen is initialized
    fetchCartProducts(context.read<cartProvider>());
  }

  Future<void> fetchCartProducts(cartProvider myCart) async {
    await myCart.getCartProduct();
    print(myCart.cartProducts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 185 * SizeConfig.verticalBlock, // Set the height of the AppBar
        flexibleSpace: Container(
          decoration:const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF223F4A), // Start color
                Color(0xFF5095B0), // End color
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20), // Rounded bottom-left corner
              bottomRight: Radius.circular(20), // Rounded bottom-right corner
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: SizeConfig.textRatio * 15,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Cart',
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 20 * SizeConfig.textRatio,
                    ),
                  ),
                  IconButton(onPressed:(){ Navigator.pushNamed(context , Profile.id);},
                      icon: Icon(Icons.account_circle_outlined , size: 24 * SizeConfig.textRatio,color: Colors.white,)),
                ],
              ),

              Row(
                children: [
                  CircleAvatar(
                    child: Container(
                      child: CircleAvatar(),
                    ),
                  )
                ],
              )
            ],
          ),
        ),



        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), // Rounded bottom-left corner
            bottomRight: Radius.circular(20), // Rounded bottom-right corner
          ),
        ),
      ),

      body: Consumer<cartProvider>(
        builder: (context, myCart, child) {
          if (myCart.cartProducts.isEmpty) {
            return Center(child: Text('Your cart is empty'));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: myCart.cartProducts.length,
            itemBuilder: (context, index) {

              return Container(
                child: Text('${myCart.cartProducts[index].Quantity}'),
              );
            },
          );
        },
      ),
    );
  }
}