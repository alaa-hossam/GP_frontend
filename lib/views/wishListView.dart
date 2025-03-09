import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Providers/ProductProvider.dart';
import 'package:gp_frontend/SqfliteCodes/wishList.dart';
import 'package:gp_frontend/widgets/customizeWishProduct.dart';
import 'package:provider/provider.dart';

import '../Providers/CategoryProvider.dart';
import '../widgets/Dimensions.dart';
import '../widgets/customizeCategory.dart';

class wishListView extends StatefulWidget {
  static String id = "wishListScreen";

  wishListView({super.key});

  @override
  State<wishListView> createState() => _wishListViewState();
}

class _wishListViewState extends State<wishListView> {
  wishList myWishList = wishList();
  int selectedIndex = 0;
  late productProvider wishProvider = productProvider();


   wishProducts() async{
    await wishProvider.getWishProducts();
    print("before provider");
    print(wishProvider.wishListProducts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 85 * SizeConfig.verticalBlock, // Set the height of the AppBar
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
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: SizeConfig.textRatio * 15,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Wishlist',
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 20 * SizeConfig.textRatio,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), // Rounded bottom-left corner
            bottomRight: Radius.circular(20), // Rounded bottom-right corner
          ),
        ),
      ),
      body: ListView(
        children: [
          Consumer<CategoryProvider>(
            builder: (context, categoryProvider, child) {
              if (categoryProvider.categories.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: SizeConfig.horizontalBlock,
                  height: 43 * SizeConfig.verticalBlock,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryProvider.categories.length,
                    itemBuilder: (context, index) {
                      bool isSelected = index == selectedIndex;
                      var category = categoryProvider.categories[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Row(
                          children: [
                            Customizecategory("${category.name}", isSelected),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          Consumer<productProvider>(
            builder: (context, productProvider, child) {
              print("inside the provider itself");
              return FutureBuilder<void>(
                future: wishProducts(),
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
                      itemCount: wishProvider.wishListProducts.length,
                      itemBuilder: (context, index) {
                        final product = wishProvider.wishListProducts[index];
                        return customizeWishProuct(
                          product['imageUrl'],
                          product['name'],
                          product['category']['name'],
                          product['lowestCustomPrice'].toDouble(),
                          product['averageRating'].toDouble(),
                          product['id']
                        );
                      },
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}