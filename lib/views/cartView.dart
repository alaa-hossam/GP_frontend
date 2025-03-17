import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Providers/cartProvider.dart';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import '../SqfliteCodes/cart.dart'; // Import your Cart class

class cartScreen extends StatefulWidget {
  static String id = "cartScreen";
  const cartScreen({super.key});

  @override
  State<cartScreen> createState() => _cartScreenState();
}

class _cartScreenState extends State<cartScreen> {
  Token myToken = Token();
  List<dynamic> cartProducts = [];
  Map<dynamic, int> finalProductCounts = {};
  Cart cart = Cart();

  // @override
  // void initState() {
  //   super.initState();
  //   // Fetch cart products when the screen is initialized
  //   // cart.recreateProductsTable();
  //   // fetchCartProducts();
  //
  // }

  Future<void> fetchCartProducts() async {
    final myCartProvider = Provider.of<cartProvider>(context, listen: false);
    var result = await myCartProvider.getCartProduct();
    cartProducts = result['cartProducts']; // Get the cart products
    finalProductCounts = result['finalProductCounts'];
    // setState(() {}); // Update the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
        ),
        body: FutureBuilder<void>(
          future: fetchCartProducts(),
          builder: (context, snapshot) {
            print("inside caller");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              print("try");
              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: cartProducts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(10.0 * SizeConfig.verticalBlock),
                      child: Container(
                        width: 358 * SizeConfig.horizontalBlock,
                        height: 150 * SizeConfig.verticalBlock,
                        decoration: BoxDecoration(
                          color:const Color(0x50E9E9E9),
                          border: Border.all(color: SizeConfig.iconColor),
                          borderRadius: BorderRadius.all(Radius.circular(10 * SizeConfig.verticalBlock))
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(5.0 * SizeConfig.verticalBlock),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                child: Image.network(
                                  cartProducts[index]['finalProduct']['imageUrl'],
                                  width: 140 * SizeConfig.horizontalBlock,
                                  height: 140 * SizeConfig.verticalBlock,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              SizedBox(
                                width: 10 * SizeConfig.horizontalBlock,
                              ),
                              Column(
                                children: [
                                  Text(
                                      cartProducts[index]['name'],
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0x80000000),
                                    ),
                                  ),
                                  // Text(
                                  //   cartProducts[index]['category']['name'],
                                  //   style: GoogleFonts.roboto(
                                  //     fontSize: 16,
                                  //     fontWeight: FontWeight.bold,
                                  //     color: Color(0x80000000),
                                  //   ),
                                  // ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
          },
        )

        // cartProducts.isEmpty
        //     ? Center(child: Text('Your cart is empty'))
        //     : ListView.builder(
        //   itemCount: cartProducts.length,
        //   itemBuilder: (context, index) {
        //     var product = cartProducts[index];
        //     final imageUrl = product['imageUrl']; // Fetch the image URL
        //     final finalProduct = product['finalProduct'];
        //     final productId = finalProduct['id'].toString(); // Get the final product ID
        //     final count = finalProductCounts[productId] ?? 1; // Get the count
        //
        //
        //
        //     return Padding(
        //       padding: EdgeInsets.all(8.0 * SizeConfig.verticalBlock),
        //       child: Container(
        //         width: 358 * SizeConfig.horizontalBlock,
        //         height: 150 * SizeConfig.verticalBlock,
        //         decoration: BoxDecoration(
        //           color: const Color(0x50E9E9E9),
        //           border: Border.all(
        //             color: SizeConfig.iconColor,
        //             width: 1,
        //           ),
        //         ),
        //         child: Row(
        //           children: [
        //             // Display the product image
        //             if (imageUrl != null)
        //               ClipRRect(
        //                 borderRadius: BorderRadius.circular(8.0),
        //                 child: Image.network(
        //                   finalProduct['imageUrl'],
        //                   width: 100 * SizeConfig.horizontalBlock,
        //                   height: 100 * SizeConfig.verticalBlock,
        //                   fit: BoxFit.cover,
        //                 ),
        //               ),
        //             SizedBox(width: 10 * SizeConfig.horizontalBlock),
        //             // Display product details
        //             Expanded(
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Text(
        //                     product['name'] ?? 'No Name',
        //                     style: TextStyle(
        //                       fontSize: 18 * SizeConfig.textRatio,
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   ),
        //                   SizedBox(height: 5 * SizeConfig.verticalBlock),
        //                   Text(
        //                     'Price: ${finalProduct['customPrice']} EGP',
        //                     style: TextStyle(
        //                       fontSize: 16 * SizeConfig.textRatio,
        //                     ),
        //                   ),
        //                   SizedBox(height: 5 * SizeConfig.verticalBlock),
        //                   Text(
        //                     'Category: ${product['category']}',
        //                     style: TextStyle(
        //                       fontSize: 16 * SizeConfig.textRatio,
        //                     ),
        //                   ),
        //                   SizedBox(height: 5 * SizeConfig.verticalBlock),
        //                   // Display the count of the final product
        //                   Text(
        //                     'Quantity: $count',
        //                     style: TextStyle(
        //                       fontSize: 16 * SizeConfig.textRatio,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     );
        //   },
        // ),
        );
  }
}
