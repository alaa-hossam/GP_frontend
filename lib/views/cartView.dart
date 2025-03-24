import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Providers/cartProvider.dart';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import '../SqfliteCodes/cart.dart';
import '../widgets/customizeButton.dart';
import '../widgets/customizeTextFormField.dart';
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
  TextEditingController voucher = TextEditingController();
  String? _selectedOption; // Variable to store the selected option

  // List of dropdown options
  final List<String> _options = [
    'Choose', // Default option
    'Voucher',
    'Gift Cards',
    'Loyalty Points',
  ];

  // Widget CircularProgressIndicator()

  @override
  void initState() {
    super.initState();
    // Fetch cart products when the screen is initialized
    fetchCartProducts(context.read<cartProvider>());

  }

  Future<void> fetchCartProducts(cartProvider myCart) async {
    // cart.recreateProductsTable();

    await myCart.getCartProduct();
    print("cart Product Length");
    print(myCart.cartProducts.length);
  }

   double getTotalPrice(cartProvider myCart){
    double price = 0;
    for(var product in myCart.cartProducts){
      print("in for");
      print(product.Quantity);
      price += product.price * product.Quantity! ?? 0;
    }
    return price;
  }


  void insertProductData(String id, String finalId) async {
    Cart myCart = Cart();

    print("insert product in cart");
    await myCart.addProduct(id, finalId);
    print('Product data inserted!');

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight:
            185 * SizeConfig.verticalBlock, // Set the height of the AppBar
        flexibleSpace: Container(
          decoration: const BoxDecoration(
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
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 45 * SizeConfig.verticalBlock,
              ),
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
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Profile.id);
                      },
                      icon: Icon(
                        Icons.account_circle_outlined,
                        size: 24 * SizeConfig.textRatio,
                        color: Colors.white,
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: SizeConfig.secondColor,
                            radius: 25 * SizeConfig.verticalBlock,
                          ),
                          Positioned(
                            top: 5 * SizeConfig.verticalBlock,
                            left: 5 * SizeConfig.verticalBlock,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20 * SizeConfig.verticalBlock,
                            ),
                          ),
                          Positioned(
                            top: 10 * SizeConfig.verticalBlock,
                            right: 10 * SizeConfig.verticalBlock,
                            child: CircleAvatar(
                              backgroundColor: SizeConfig.secondColor,
                              radius: 15 * SizeConfig.verticalBlock,
                              child: Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      Text(
                        "step 1",
                        style: GoogleFonts.roboto(
                            fontSize: 12, color: Colors.white),
                      ),
                      SizedBox(
                        height: 5 * SizeConfig.verticalBlock,
                      ),
                      Text(
                        "View Cart",
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: 35.0 * SizeConfig.verticalBlock),
                    child: Container(
                      width: 50 * SizeConfig.horizontalBlock,
                      height: 4 * SizeConfig.verticalBlock,
                      color: const Color(0x50E9E9E9),
                    ),
                  ),
                  Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0x503C3C3C),
                            radius: 25 * SizeConfig.verticalBlock,
                          ),
                          Positioned(
                            top: 5 * SizeConfig.verticalBlock,
                            left: 5 * SizeConfig.verticalBlock,
                            child: CircleAvatar(
                              backgroundColor: Color(0x50E9E9E9),
                              radius: 20 * SizeConfig.verticalBlock,
                            ),
                          ),
                          Positioned(
                            top: 10 * SizeConfig.verticalBlock,
                            right: 10 * SizeConfig.verticalBlock,
                            child: CircleAvatar(
                              backgroundColor: Color(0x503C3C3C),
                              radius: 15 * SizeConfig.verticalBlock,
                              child: Icon(
                                Icons.format_list_bulleted_outlined,
                                color: Color(0x50E9E9E9),
                              ),
                            ),
                          )
                        ],
                      ),
                      Text(
                        "step 2",
                        style: GoogleFonts.roboto(
                            fontSize: 12, color: Colors.white),
                      ),
                      SizedBox(
                        height: 5 * SizeConfig.verticalBlock,
                      ),
                      Text(
                        "Check Out",
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Color(0x50E9E9E9),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: 35.0 * SizeConfig.verticalBlock),
                    child: Container(
                      width: 50 * SizeConfig.horizontalBlock,
                      height: 4 * SizeConfig.verticalBlock,
                      color: const Color(0x50E9E9E9),
                    ),
                  ),
                  Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0x503C3C3C),
                            radius: 25 * SizeConfig.verticalBlock,
                          ),
                          Positioned(
                            top: 5 * SizeConfig.verticalBlock,
                            left: 5 * SizeConfig.verticalBlock,
                            child: CircleAvatar(
                              backgroundColor: Color(0x50E9E9E9),
                              radius: 20 * SizeConfig.verticalBlock,
                            ),
                          ),
                          Positioned(
                            top: 10 * SizeConfig.verticalBlock,
                            right: 10 * SizeConfig.verticalBlock,
                            child: CircleAvatar(
                              backgroundColor: Color(0x503C3C3C),
                              radius: 15 * SizeConfig.verticalBlock,
                              child: Icon(
                                Icons.checklist,
                                color: Color(0x50E9E9E9),
                              ),
                            ),
                          )
                        ],
                      ),
                      Text(
                        "step 3",
                        style: GoogleFonts.roboto(
                            fontSize: 12, color: Colors.white),
                      ),
                      SizedBox(
                        height: 5 * SizeConfig.verticalBlock,
                      ),
                      Text(
                        "Order review",
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Color(0x50E9E9E9),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
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
            return Center(child: Text("your Cart is Empty"));
          }
          double totalPrice = getTotalPrice(myCart);
          return ListView(
            children: [
              SizedBox(
                height: 400 * SizeConfig.verticalBlock,
                child: ListView.builder(
                  itemCount: myCart.cartProducts.length,
                  itemBuilder: (context, index) {

                    if (myCart.cartProducts[index].Quantity == null) {
                      myCart.cartProducts[index].Quantity = 0;
                    }
                    return Padding(
                      padding: EdgeInsets.only(
                          top: 5 * SizeConfig.verticalBlock,
                          left: 5 * SizeConfig.horizontalBlock,
                          right: 5 * SizeConfig.horizontalBlock),
                      child: Container(
                        width: 358 * SizeConfig.horizontalBlock,
                        height: 150 * SizeConfig.verticalBlock,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0x50E9E9E9),
                          border: Border.all(width: 2, color: SizeConfig.iconColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(2.0 * SizeConfig.verticalBlock),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                child: Image.network(
                                  myCart.cartProducts[index].imageURL,
                                  width: 140 * SizeConfig.horizontalBlock,
                                  height: 140 * SizeConfig.verticalBlock,
                                  fit: BoxFit
                                      .cover, // Ensures the image fills the space
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100 * SizeConfig.horizontalBlock,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 10 * SizeConfig.verticalBlock,
                                  // bottom: 10 * SizeConfig.verticalBlock,
                                ),
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          myCart.cartProducts[index].name,
                                          style: GoogleFonts.roboto(
                                              fontSize: 16 * SizeConfig.textRatio,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          myCart.cartProducts[index].category!,
                                          style: GoogleFonts.rubik(
                                            fontSize: 11 * SizeConfig.textRatio,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0x50000000),
                                          ),
                                        ),

                                        SizedBox(
                                          width: 80 * SizeConfig.horizontalBlock,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: myCart.cartProducts[index].variations?.length ?? 0,
                                              itemBuilder: (context , i){
                                                final product = myCart.cartProducts[index];
                                                final variations = product.variations;
                                                print("indexxxxxxxxxxxxxxxxx");
                                                print(index);
                                                print(myCart.cartProducts[i].variations);
                                                if (variations != null && variations.isNotEmpty && i < variations.length) {
                                                  final variation = variations[i];

                                                  final variationType = variation?['productVariation']?['variationType'] ?? 'N/A';
                                                  final variationValue = variation?['productVariation']?['variationValue'] ?? 'N/A';

                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(variationType + ":" + variationValue  , style: GoogleFonts.roboto(color: Color(0x50000000), fontSize: 12 * SizeConfig.textRatio),),

                                                    ],
                                                  );
                                                }

                                              }
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10 * SizeConfig.verticalBlock,
                                        ),


                                      ],
                                    ),
                                    Positioned(
                                        bottom: 0 ,
                                        child:    Text(
                                          '${myCart.cartProducts[index].price * myCart.cartProducts[index].Quantity!} EG',
                                          style: GoogleFonts.roboto(
                                              fontSize: 20 * SizeConfig.textRatio,
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Color(0xFFD4931C),
                                    ),
                                    Text(
                                      '${myCart.cartProducts[index].rate}',
                                      style: GoogleFonts.rubik(
                                          color: Color(0x50000000),
                                          fontSize: 11 * SizeConfig.textRatio),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10 * SizeConfig.verticalBlock,
                                      top: 10 * SizeConfig.verticalBlock,
                                      bottom: 3 * SizeConfig.verticalBlock,
                                      right: 5 * SizeConfig.verticalBlock),
                                  child: Container(
                                      width: 110 * SizeConfig.horizontalBlock,
                                      height: 42 * SizeConfig.verticalBlock,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: SizeConfig.iconColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  10 * SizeConfig.textRatio))),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 10.0 *
                                                      SizeConfig.verticalBlock
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    final product = myCart.cartProducts[index];

                                                    if (product.Quantity! > 1) {
                                                      print("...");
                                                      // Decrease the quantity if it's greater than 1
                                                      product.Quantity = (product.Quantity ?? 0) - 1;
                                                      myCart.deleteCartProduct(product.finalId ?? "");
                                                      // fetchCartProducts(myCart);

                                                    } else {
                                                      cart.deleteAllProduct(product.finalId??"");
                                                      fetchCartProducts(myCart);
                                                      // Delete the item from the database
                                                    }

                                                    // Print the updated cart for debugging
                                                    print(myCart.cartProducts);
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.minimize_outlined,
                                                  size: 20 * SizeConfig.textRatio,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "${myCart.cartProducts[index].Quantity}",
                                              style: GoogleFonts.roboto(
                                                  fontSize:
                                                      16 * SizeConfig.textRatio),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  final product = myCart.cartProducts[index];

                                                  myCart.cartProducts[index].Quantity =
                                                      (myCart.cartProducts[index].Quantity ?? 0) + 1;
                                                  insertProductData(product.id,
                                                      product.finalId ??"");
                                                });
                                              },
                                              icon: Icon(
                                                Icons.add,
                                                size: 20 * SizeConfig.textRatio,
                                              ),
                                            ),
                                          ])),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 5 * SizeConfig.verticalBlock,
              ),
              Stack(
                children: [
                  Center(
                    child: MyTextFormField(
                      controller: voucher,
                      hintName: "Add Voucher",
                    ),
                  ),
                Positioned(
                  right: 15,
                    top:15,
                    child:
                    Container(
                      width: 100 * SizeConfig.horizontalBlock,
                      height: 31 * SizeConfig.verticalBlock,// Set the width to 80
                      decoration: BoxDecoration(
                        color: SizeConfig.secondColor, // Background color
                        borderRadius: BorderRadius.circular(10), // Border radius
                        border: Border.all(
                          color: Colors.blue, // Border color
                          width: 1, // Border width
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8), // Inner padding
                      child: DropdownButton<String>(
                        value: _selectedOption, // Current selected value
                        hint: Text('Choose' , style: GoogleFonts.roboto(color: Colors.white),), // Default hint text
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedOption = newValue; // Update the selected value
                          });
                        },
                        items: _options.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        iconEnabledColor: Colors.white,
                        isExpanded: true, // Expand the dropdown to fill the container
                        underline: Container(), // Remove the default underline
                        icon: null,
                        dropdownColor: SizeConfig.secondColor,// Remove the default arrow
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 14, // Adjust font size to fit the width
                        ),
                      ),
                    )                )
                ],
              ),
              SizedBox(height: 20 * SizeConfig.verticalBlock,),
              Row(

                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Total Price" , style: GoogleFonts.rubik( fontSize: 24 * SizeConfig.textRatio , fontWeight: FontWeight.bold),),
                  Text('${totalPrice}' ,  style: GoogleFonts.rubik( fontSize: 24 * SizeConfig.textRatio , fontWeight: FontWeight.bold)),
                ],
              ),
              Padding(
                padding:  EdgeInsets.all(20.0 * SizeConfig.verticalBlock),
                child: customizeButton(buttonColor: SizeConfig.iconColor,buttonName: "Check Out",
                  fontColor: Colors.white, width: 370 * SizeConfig.horizontalBlock,
                height: 50 * SizeConfig.verticalBlock,onClickButton: (){},),
              )
            ],

          );
        },
      ),
    );
  }
}
