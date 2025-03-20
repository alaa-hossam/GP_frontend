import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:provider/provider.dart';

import '../Providers/CategoryProvider.dart';
import '../Providers/ProductProvider.dart';
import '../widgets/customProduct.dart';
import '../widgets/customizeCategory.dart';

class GiftRecommendationProducts extends StatefulWidget {
  static String id = "GiftRecommendationProductsScreen";
  const GiftRecommendationProducts({super.key});

  @override
  State<GiftRecommendationProducts> createState() => _GiftRecommendationProductsState();
}

class _GiftRecommendationProductsState extends State<GiftRecommendationProducts> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
          'Gift Picker Recommendations',
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
              if (productProvider.giftRecommendProducts.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // Disable GridView's scrolling
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two products per row
                    crossAxisSpacing: 10.0, // Spacing between columns
                    mainAxisSpacing: 10.0, // Spacing between rows
                    childAspectRatio: 0.7, // Adjust based on your design
                  ),
                  itemCount: productProvider.giftRecommendProducts.length,
                  itemBuilder: (context, index) {
                    var product = productProvider.giftRecommendProducts[index];
                    return customProduct(
                      product.imageURL,
                      product.name,
                      Category:product.category,
                      product.price,
                      product.rate,
                      product.id,
                      false,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
