import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/CategoryProvider.dart';
import '../Providers/ProductProvider.dart';
import '../widgets/BottomBar.dart';
import '../widgets/Dimensions.dart';
import '../widgets/SideButton.dart';
import '../widgets/customProduct.dart';
import '../widgets/customizeCategory.dart';
import '../widgets/customizeTextFormField.dart';
import 'ProfileView.dart';
import 'logInView.dart';

class browseProducts extends StatefulWidget {
  static String id = "browseProductsScreen";

  const browseProducts({super.key});
  @override
  State<browseProducts> createState() => _BrowseProductsState();
}

class _BrowseProductsState extends State<browseProducts> {
  TextEditingController search = TextEditingController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      drawer: Drawer(
        width: 223 * SizeConfig.horizontalBlock,
        backgroundColor: Colors.white,
        child: Stack(
          children: [
            ListView(
              children: [
                Stack(
                  children: [
                    Container(
                      color: const Color(0xFFE9E9E9),
                      height: 251 * SizeConfig.verticalBlock,
                      width: 223 * SizeConfig.horizontalBlock,
                    ),
                    Positioned(
                      left: 15, // Align to the left
                      bottom: 15, // Align to the bottom
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start, // Align text to the left
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, // Circular shape
                              border: Border.all(
                                color: Color(0xFF5095B0), // Border color
                                width: 3, // Border width
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 50, // Size of the CircleAvatar
                              backgroundImage:
                              AssetImage('assets/images/p1.jpg'), // Image
                            ),
                          ),
                          Text(
                            "my name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20 * SizeConfig.textRatio),
                          ),
                          Text(
                            "myemail.gmail.com",
                            style:
                            TextStyle(fontSize: 14 * SizeConfig.textRatio),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 10 * SizeConfig.textRatio,
                      top: 10 * SizeConfig.textRatio),
                  child: Column(
                    children: [
                      sideButton("My Account", Icons.account_circle_outlined,
                          SizeConfig.iconColor,() {
                            Navigator.pushNamed(context, Profile.id);
                          }),
                      sideButton("My orders", Icons.shopping_cart_outlined,
                          SizeConfig.iconColor, () {
                            Navigator.pushNamed(context, Profile.id);
                          }),
                      sideButton("History", Icons.history_outlined,
                          SizeConfig.iconColor, () {
                            Navigator.pushNamed(context, Profile.id);
                          }),
                      sideButton(
                          "My posts", Icons.post_add, SizeConfig.iconColor, () {
                        Navigator.pushNamed(context, Profile.id);
                      }),
                      sideButton("compare Products", Icons.compare_outlined,
                          SizeConfig.iconColor, () {
                            Navigator.pushNamed(context, Profile.id);
                          }),
                      sideButton("Recommend Gifts",
                          Icons.card_giftcard_outlined, SizeConfig.iconColor, () {
                            Navigator.pushNamed(context, Profile.id);
                          }),
                      sideButton("Event reminder",
                          Icons.event_available_outlined, SizeConfig.iconColor, () {
                            Navigator.pushNamed(context, Profile.id);
                          }),
                      sideButton("Add Advertisement",
                          Icons.camera_roll_outlined, SizeConfig.iconColor, () {
                            Navigator.pushNamed(context, Profile.id);
                          }),
                      sideButton("Join as Handcrafter",
                          Icons.shopping_bag_outlined, SizeConfig.iconColor, () {
                            Navigator.pushNamed(context, Profile.id);
                          }),
                    ],
                  ),
                ),
              ],
            ),

            // Log Out Button at the Bottom-Left
            Positioned(
              left: 10, // Align to the left
              bottom: 10, // Align to the bottom
              child: sideButton("Log Out", Icons.logout_outlined, Colors.red, () {
                Navigator.pushReplacementNamed(context, logIn.id);
              }),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_none, size:24 * SizeConfig.textRatio,),
              ),
              Icon(
                Icons.shopping_cart_outlined,
                size:24 * SizeConfig.textRatio,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, Profile.id);
                },
                icon: Icon(Icons.account_circle_outlined, size:24 * SizeConfig.textRatio,),
              ),
            ],
          )
        ],
        title: Row(
          children: [
            Image(
              image: AssetImage("assets/images/Frame 36920.png"),
              width: SizeConfig.textRatio * 40,
              height: SizeConfig.textRatio * 40,
              fit: BoxFit.cover,
            ),
            Text(
              "SAN3A",
              style: TextStyle(
                color: Color(0xFF073477),
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontFamily: 'Poppins',
                fontSize: SizeConfig.textRatio * 24,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: SizeConfig.horizontalBlock * 5,
            children: [
              MyTextFormField(
                controller: search,
                hintName: "Search",
                icon: Icons.search,
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: SizeConfig.iconColor,
                    size: 24 * SizeConfig.textRatio,
                  ),
                  onPressed: () {},
                ),
                width: 253 * SizeConfig.horizontalBlock,
                height: 45 * SizeConfig.verticalBlock,
              ),
              Container(
                width:48 * SizeConfig.horizontalBlock,
                height: 45 * SizeConfig.verticalBlock,
                decoration: BoxDecoration(
                    color: Color(0x80E9E9E9),
                    borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: Icon(Icons.tune , size: 24 * SizeConfig.textRatio,),
              ),
              Container(
                width:48 * SizeConfig.horizontalBlock,
                height: 45 * SizeConfig.verticalBlock,
                decoration: BoxDecoration(
                    color: Color(0x80E9E9E9),
                    borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: Icon(Icons.compare_outlined , size: 24 * SizeConfig.textRatio,),
              ),
            ],
          ),
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
              if (productProvider.products.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 250 * SizeConfig.verticalBlock, // Set a fixed height
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: (productProvider.products.length / 2).ceil(),
                    itemBuilder: (context, index) {
                      var firstProductIndex = index * 2;
                      var secondProductIndex = firstProductIndex + 1;
                      var product1 = productProvider.products[firstProductIndex];
                      var product2 = secondProductIndex < productProvider.products.length
                          ? productProvider.products[secondProductIndex]
                          : null;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customProduct(
                            product1.imageURL,
                            product1.name,
                            product1.category,
                            product1.price,
                            product1.rate,
                            product1.id
                          ),
                          SizedBox(width: 10 * SizeConfig.horizontalBlock),
                          product2 != null
                              ? customProduct(
                            product2.imageURL,
                            product2.name,
                            product2.category,
                            product2.price,
                            product2.rate,
                            product2.id
                          )
                              : SizedBox.shrink(),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(selectedIndex: 0),
    );
  }
}




