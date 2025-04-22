import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:gp_frontend/views/HandcrafterRequest.dart';
import 'package:gp_frontend/views/RecommendGiftView.dart';
import 'package:gp_frontend/views/compareView.dart';
import 'package:provider/provider.dart';
import '../Models/CategoryModel.dart';
import '../Providers/CategoryProvider.dart';
import '../Providers/ProductProvider.dart';
import '../SqfliteCodes/Token.dart';
import '../widgets/BottomBar.dart';
import '../widgets/Dimensions.dart';
import '../widgets/SideButton.dart';
import '../widgets/customProduct.dart';
import '../widgets/customizeCategory.dart';
import '../widgets/customizeTextFormField.dart';
import 'MyHandcrafterProfile.dart';
import 'ProfileView.dart';
import 'eventsView.dart';
import 'historyView.dart';
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
  int selectedChildIndex = 0;
  bool showCompare = false;
  bool isLoading = false;
  List<productModel> comparedProducts = [];
  late productProvider prodProvider;
  late CategoryProvider catProvider;
  String? selectedCategoryId;
  List<CategoryModel> categoryChildren = [];

  @override
  void initState() {
    super.initState();
    prodProvider = Provider.of<productProvider>(context, listen: false);
    catProvider = Provider.of<CategoryProvider>(context, listen: false);

    prodProvider.products.clear();
    prodProvider.fetchProducts('0');
    catProvider.fetchCategories();
  }
  void _handleCompare(productModel product) {
    bool exist = false;
    int index = 0;
    setState(() {
      for (int i = 0; i < comparedProducts.length; i++) {
        if (comparedProducts[i].id == product.id) {
          exist = true;
          index = i;
          break;
        }
      }
      if (!comparedProducts.isEmpty) {
        if (comparedProducts.length == 2) {
          if (exist) {
            comparedProducts.remove(comparedProducts[index]);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("You can only compare 2 products.")),
            );
          }
        } else if (comparedProducts.length != 2) {
          if (exist) {
            comparedProducts.remove(comparedProducts[index]);
          } else {
            comparedProducts.add(product);
          }
        }
      } else {
        comparedProducts.add(product);
      }
    });
  }


  Future<void> _handleCategorySelection(CategoryModel category) async {
    setState(() {
      selectedIndex = catProvider.categories.indexOf(category);
      selectedCategoryId = category.id; // Set the selected category ID
      isLoading = true; // Set loading state to true
      selectedChildIndex = 0;
    });

    // Fetch category children
    await catProvider.fetchCategoryChildren(category.id);

    // Fetch products for the selected category
    await prodProvider.fetchProducts(selectedCategoryId!);

    // Store category children
    setState(() {
      categoryChildren = catProvider.categoryCildren;
      isLoading = false; // Reset loading state
    });
  }

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
                      left: 15,
                      bottom: 15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFF5095B0),
                                width: 3,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 50,
                              backgroundImage:
                              AssetImage('assets/images/p1.jpg'),
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
                          SizeConfig.iconColor, () async{
                            final token = Token();
                            final role = await token.getRole('SELECT ROLE FROM TOKENS');
                            print(role);
                            // Navigate to the appropriate profile based on the role
                            if (role == 'Handicrafter') {
                              Navigator.pushNamed(context, MyHandcrafterProfile.id);
                            } else if (role == 'Client') {
                              Navigator.pushNamed(context, Profile.id);
                            }
                          }),
                      sideButton("My orders", Icons.shopping_cart_outlined,
                          SizeConfig.iconColor, () {
                            Navigator.pushNamed(context, Profile.id);
                          }),
                      sideButton("History", Icons.history_outlined,
                          SizeConfig.iconColor, () {
                            Navigator.pushNamed(context, HistoryProducts.id);
                          }),
                      sideButton(
                          "My posts", Icons.post_add, SizeConfig.iconColor, () {
                        Navigator.pushNamed(context, Profile.id);
                      }),
                      sideButton("Compare Products", Icons.compare_outlined,
                          SizeConfig.iconColor, () {
                            Navigator.pushNamed(context, Profile.id);
                          }),
                      sideButton(
                          "Recommend Gifts",
                          Icons.card_giftcard_outlined,
                          SizeConfig.iconColor, () {
                        Navigator.pushNamed(context, RecommendGift.id);
                      }),
                      sideButton(
                          "Event reminder",
                          Icons.event_available_outlined,
                          SizeConfig.iconColor, () {
                        Navigator.pushNamed(context, EventsView.id);
                      }),
                      sideButton("Add Advertisement",
                          Icons.camera_roll_outlined, SizeConfig.iconColor, () {
                            Navigator.pushNamed(context, Profile.id);
                          }),
                      sideButton(
                          "Join as Handcrafter",
                          Icons.shopping_bag_outlined,
                          SizeConfig.iconColor, () {
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
              child:
              sideButton("Log Out", Icons.logout_outlined, Colors.red, () {
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
                icon: Icon(Icons.notifications_none,
                    size: 24 * SizeConfig.textRatio),
              ),
              Icon(
                Icons.shopping_cart_outlined,
                size: 24 * SizeConfig.textRatio,
              ),
              IconButton(
                onPressed: () async{
                  final token = Token();
                  final role = await token.getRole('SELECT ROLE FROM TOKENS');
                  print(role);
                  // Navigate to the appropriate profile based on the role
                  if (role == 'Handicrafter') {
                    Navigator.pushNamed(context, MyHandcrafterProfile.id);
                  } else if (role == 'Client') {
                    Navigator.pushNamed(context, Profile.id);
                  }                },
                icon: Icon(Icons.account_circle_outlined,
                    size: 24 * SizeConfig.textRatio),
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
      body:
      Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    SizedBox(width: 10 * SizeConfig.horizontalBlock),
                    Container(
                      width: 48 * SizeConfig.horizontalBlock,
                      height: 45 * SizeConfig.verticalBlock,
                      decoration: BoxDecoration(
                        color: Color(0x80E9E9E9),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(Icons.tune, size: 24 * SizeConfig.textRatio),
                    ),
                    SizedBox(width: 10 * SizeConfig.horizontalBlock),
                    Container(
                      width: 48 * SizeConfig.horizontalBlock,
                      height: 45 * SizeConfig.verticalBlock,
                      decoration: BoxDecoration(
                        color: showCompare
                            ? SizeConfig.iconColor
                            : Color(0x80E9E9E9),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.compare_outlined,
                            size: 24 * SizeConfig.textRatio),
                        onPressed: () {
                          setState(() {
                            showCompare = !showCompare;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                // Base Category List
                  Consumer<CategoryProvider>(
                  builder: (context, catProvider, child) {
                    if (catProvider.categories.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 43 * SizeConfig.verticalBlock,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: catProvider.categories.length,
                          itemBuilder: (context, index) {
                            bool isSelected = index == selectedIndex;
                            var category = catProvider.categories[index];
                            return GestureDetector(
                              onTap: () {
                                  _handleCategorySelection(category);
                              },
                              child: Row(
                                children: [
                                  Customizecategory(
                                    "${category.name}",
                                    isSelected,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),

                // Category Children List
                if (categoryChildren.isNotEmpty)
                  Consumer<CategoryProvider>(
                    builder: (context, catProvider, child) {
                      if (catProvider.categoryCildren.isEmpty) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 43 * SizeConfig.verticalBlock,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: catProvider.categoryCildren.length,
                            itemBuilder: (context, index) {
                              bool isSelected = selectedChildIndex == index; // Use the correct index for selection
                              var category = catProvider.categoryCildren[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedChildIndex = 0; // Update selected index
                                    _handleCategorySelection(category); // Fetch products for selected child category
                                  });
                                },
                                child: Row(
                                  children: [
                                    Customizecategory(
                                      "${category.name}",
                                      isSelected,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),

                // Show loading indicator instead of products when loading
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else
                // Products Grid
                  Consumer<productProvider>(
                    builder: (context, prodProvider, child) {
                      if (prodProvider.products.isEmpty) {
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
                          itemCount: prodProvider.products.length,
                          itemBuilder: (context, index) {
                            var product = prodProvider.products[index];
                            return customProduct(
                              product.imageURL,
                              product.name,
                              Category:product.category,
                              product.price,
                              product.rate,
                              product.id,
                              showCompare,
                              onComparePressed: _handleCompare,
                              comparedNum: comparedProducts.length,

                            );
                          },
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          if (showCompare && !comparedProducts.isEmpty)
            Positioned(
              bottom: 2 * SizeConfig.verticalBlock,
              left: 17 * SizeConfig.horizontalBlock,
              child: GestureDetector(
                child: Container(
                  width: 370 * SizeConfig.verticalBlock,
                  height: 50 * SizeConfig.horizontalBlock,
                  decoration: BoxDecoration(
                    color: SizeConfig.iconColor,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Center(
                    child: Text(
                      "Compare ",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 20 * SizeConfig.textRatio,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, compareScreen.id , arguments: comparedProducts);
                },
              ),
            )
        ],
      ),
      bottomNavigationBar: BottomBar(selectedIndex: 0, isVisible: !showCompare),
    );
  }
}