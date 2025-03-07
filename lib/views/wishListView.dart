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
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: const Color(0xFF292929),
            size: SizeConfig.textRatio * 15,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.account_circle_outlined,
              color: const Color(0xFF292929),
              size: SizeConfig.textRatio * 24,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        title: Text(
          'Wishlist',
          style: GoogleFonts.rubik(
            color: Color(0x80000000),
            fontSize: 20 * SizeConfig.textRatio,
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
                            Customizecategory("${category}", isSelected),
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
                          product['IMAGEURL'],
                          product['NAME'],
                          product['CATEGORY'],
                          product['PRICE'],
                          product['RATE'],
                          product['ID']
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