import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:gp_frontend/views/BazarVariations.dart';
import 'package:provider/provider.dart';
import '../Providers/CategoryProvider.dart';
import '../Providers/ProductProvider.dart';
import '../widgets/customizeButton.dart';
import 'ProfileView.dart';
import '../widgets/Dimensions.dart';

class JoinBazar extends StatefulWidget {
  static String id = "joinBazar";
  const JoinBazar({super.key});

  @override
  State<JoinBazar> createState() => _JoinBazarState();
}

class _JoinBazarState extends State<JoinBazar> {
  List<String> tappedProducts = []; // Track tapped products
  late productProvider prodProvider;

  void Tapping(String product) {
    setState(() {
      if (tappedProducts.contains(product)) {
        tappedProducts.remove(product); // Remove if already tapped
      } else {
        tappedProducts.add(product); // Add if not tapped
      }
      print(tappedProducts.length);
      print(tappedProducts);
    });


  }

  @override
  void initState() {
    tappedProducts.clear();
    prodProvider = Provider.of<productProvider>(context, listen: false);
    prodProvider.products.clear();
    prodProvider.fetchHandCrafter();

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
          'Join Bazar',
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 20 * SizeConfig.textRatio,
          ),
        ),
        actions: [
          IconButton(onPressed: (){Navigator.pushNamed(context, Profile.id);}, icon: Icon(Icons.account_circle_outlined , color: Colors.white,))
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), // Rounded bottom-left corner
            bottomRight: Radius.circular(20), // Rounded bottom-right corner
          ),
        ),
      ),

      body: Stack(
        children: [
          ListView(
              children: [
                Consumer<productProvider>(
                  builder: (context, prodProvider, child) {
                    if (prodProvider.handCrafterProducts.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: prodProvider.handCrafterProducts.length,
                        itemBuilder: (context, index) {
                          var product = prodProvider.handCrafterProducts[index];
                          bool isTapped = tappedProducts.contains(product.id); // Check if product is tapped

                          return Container(
                            padding: EdgeInsets.all(5),
                            width: 170 * SizeConfig.horizontalBlock,
                            height: 250 * SizeConfig.verticalBlock,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5 * SizeConfig.textRatio),
                              ),
                              border: Border.all(
                                width: 2,
                                color: SizeConfig.iconColor, // Border color
                              ),
                              color: Color(0x50E9E9E9), // Container background color
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.2), // Lighter shadow color
                              //     offset: Offset(2.0, 2.0), // Adjust offset to reduce overlap
                              //     blurRadius: 4.0, // Reduce blur radius
                              //     spreadRadius: 1.0, // Reduce spread radius
                              //   ),
                              // ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            5 * SizeConfig.textRatio),
                                        child: Image.network(
                                          product.imageURL,
                                          width: 170 * SizeConfig.horizontalBlock,
                                          height: 165 * SizeConfig.verticalBlock,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        child: Container(
                                          width: 75 * SizeConfig.horizontalBlock,
                                          height: 32 * SizeConfig.verticalBlock,
                                          decoration: BoxDecoration(
                                            color: isTapped ? SizeConfig.iconColor : Color(0x50E9E9E9), // Button color
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              isTapped ? "Added" : "Add", // Button text
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          Tapping(product.id); // Call the Tapping function
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        product.name,
                                        style: TextStyle(fontSize: 14 * SizeConfig.textRatio),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Color(0xFFD4931C),
                                          size: 10 * SizeConfig.textRatio,
                                        ),
                                        SizedBox(width: 5 * SizeConfig.horizontalBlock),
                                        Text(
                                          '${product.rate}',
                                          style: TextStyle(fontSize: 11 * SizeConfig.textRatio),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.category?.isNotEmpty == true ? product.category! : "No Category",
                                      style: TextStyle(fontSize: 11 * SizeConfig.textRatio),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${product.price} EG',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16 * SizeConfig.textRatio),
                                    ),
                                    Container(
                                      width: 30 * SizeConfig.horizontalBlock,
                                      height: 24 * SizeConfig.verticalBlock,
                                      decoration: BoxDecoration(
                                        color: SizeConfig.iconColor,
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          size: 14 * SizeConfig.textRatio,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );                    },
                      ),
                    );
                  },

                ),
              ],
            ),

      Positioned(
        bottom: 2 * SizeConfig.verticalBlock,
        left: 12 * SizeConfig.horizontalBlock,
        child: customizeButton(buttonColor: SizeConfig.iconColor,buttonName: "Continue",
          fontColor: Colors.white, width: 370 * SizeConfig.horizontalBlock,
          height: 50 * SizeConfig.verticalBlock,onClickButton: (){Navigator.pushNamed(context,arguments:tappedProducts,BazarVariations.id);},),
      )
        ],
      ),
    );
  }
}