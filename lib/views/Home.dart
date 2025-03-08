import 'dart:async';
import 'package:gp_frontend/views/browseProducts.dart';
import 'package:gp_frontend/views/logInView.dart';
import 'package:gp_frontend/widgets/customProduct.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/ViewModels/AdvertisementsViewModel.dart';
import 'package:gp_frontend/views/ProfileView.dart';
import 'package:provider/provider.dart';
import '../Providers/CategoryProvider.dart';
import '../Providers/ProductProvider.dart';
import '../widgets/BottomBar.dart';
import '../widgets/Dimensions.dart';
import '../widgets/customizeTextFormField.dart';
import '../widgets/customizeCategory.dart';
import '../SqfliteCodes/Token.dart';
import '../widgets/SideButton.dart';
import 'SearchView.dart';

class Home extends StatefulWidget {
  static String id = "homeScreen";
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController search = TextEditingController();
  TextEditingController filter = TextEditingController();
  int selectedIndex = 0;
  productProvider myProductProvider = productProvider();

  Token token = Token();

  // Future<String> getTokens() async {
  //   Token token = Token();
  //
  //   String query = '''
  //   SELECT * FROM TOKENS
  // ''';
  //   String tokensTable = await token.getToken(query);
  //
  //   // Print the tokens
  //   print("Expired in the TOKENS table:");
  //   print(tokensTable);
  //
  //   return tokensTable;
  // }

  Future getProducts() async{
    print("all products");
    await myProductProvider.fetchProducts();
    // print("all products");
  }

  Future<void> navigate(BuildContext context) async {
    Navigator.pushNamed(context, searchView.id);
  }

  // Future<int> getTokenCount() async {
  //   // Query to count the number of rows in the TOKENS table
  //   int result =
  //       (await token.getToken('SELECT COUNT(*) as count FROM TOKENS')) as int;
  //
  //   // Get the count from the result
  //   int count = result;
  //   print(count);
  //   return count;
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    print(
        '----------------------------HOME------------------------------------');
// wishList w = wishList();
// w.initialDB();
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
                          SizeConfig.iconColor, () {
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
                      sideButton(
                          "Recommend Gifts",
                          Icons.card_giftcard_outlined,
                          SizeConfig.iconColor, () {
                        Navigator.pushNamed(context, Profile.id);
                      }),
                      sideButton(
                          "Event reminder",
                          Icons.event_available_outlined,
                          SizeConfig.iconColor, () {
                        Navigator.pushNamed(context, Profile.id);
                      }),
                      sideButton("Add Advertisement",
                          Icons.camera_roll_outlined, SizeConfig.iconColor, () {
                        Navigator.pushNamed(context, Profile.id);
                      }),
                      sideButton(
                          "Join as Handcrafter",
                          Icons.shopping_bag_outlined,
                          SizeConfig.iconColor, () {
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
              child:
                  sideButton("Log Out", Icons.logout_outlined, Colors.red, () {
                Navigator.pushReplacementNamed(context, logIn.id);
              }),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // centerTitle: true,
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_none,
                  size: 24 * SizeConfig.textRatio,
                ),
              ),
              Icon(
                Icons.shopping_cart_outlined,
                size: 24 * SizeConfig.textRatio,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, Profile.id);
                },
                icon: Icon(
                  Icons.account_circle_outlined,
                  size: 24 * SizeConfig.textRatio,
                ),
              ),
            ],
          )
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
                    onPressed: () {
                      // Handle camera icon press
                    },
                  ),
                  width: 253 * SizeConfig.horizontalBlock,
                  height: 45 * SizeConfig.verticalBlock,
                  onClickFunction: navigate),
              SizedBox(width: 20 * SizeConfig.horizontalBlock),
              Container(
                width: 48 * SizeConfig.horizontalBlock,
                height: 45 * SizeConfig.verticalBlock,
                decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Icon(
                  Icons.tune,
                  size: 24 * SizeConfig.textRatio,
                ),
              ),
              Container(
                width: 48 * SizeConfig.horizontalBlock,
                height: 45 * SizeConfig.verticalBlock,
                decoration: BoxDecoration(
                    color: Color(0x80E9E9E9),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Icon(
                  Icons.compare_outlined,
                  size: 24 * SizeConfig.textRatio,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10 * SizeConfig.verticalBlock,
          ),
          Consumer<imageProvider>(
            builder: (context, imageProvider, child) {
              return Column(
                children: [
                  SizedBox(
                    height: 160 * SizeConfig.verticalBlock,
                    child: PageView.builder(
                      controller: imageProvider.pageController,
                      itemCount: imageProvider.AdsVM.ads.length,
                      onPageChanged: (index) {
                        imageProvider
                            .updateCurrentIndex(index); // Sync current index
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            final Uri url =
                                Uri.parse(imageProvider.AdsVM.ads[index].link);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url,
                                  mode: LaunchMode.inAppWebView);
                            } else {
                              throw 'Could not launch ${imageProvider.AdsVM.ads[index].link}';
                            }
                          },
                          child: Image.asset(
                            imageProvider.AdsVM.ads[index].image,
                            width: 363 * SizeConfig.horizontalBlock,
                            height: 160 * SizeConfig.verticalBlock,
                            fit: BoxFit.fill,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10 * SizeConfig.verticalBlock),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      imageProvider.AdsVM.ads.length,
                      (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == imageProvider._currentIndex
                              ? Color(0xFFB36995)
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 10 * SizeConfig.verticalBlock),
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
          SizedBox(
            height: 10 * SizeConfig.verticalBlock,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10 * SizeConfig.horizontalBlock),
            child: Text(
              "Best Seller",
              style: TextStyle(
                  fontSize: 20 * SizeConfig.textRatio,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Consumer<productProvider>(
            builder: (context, productProvider, child) {
              if (productProvider.products.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: SizeConfig.horizontalBlock,
                  height: 250 * SizeConfig.verticalBlock,
                  child: FutureBuilder(
                    future: getProducts(), // Ensure this returns a Future
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: productProvider.products.length,
                              itemBuilder: (context, index) {
                                var product = productProvider.products[index];
                                return Row(
                                  children: [
                                    customProduct(
                                      product.imageURL,
                                      product.name,
                                      product.category,
                                      product.price,
                                      product.rate,
                                      product.id,
                                    ),
                                    SizedBox(width: 10 * SizeConfig.horizontalBlock),
                                  ],
                                );
                              },
                            );

                      }
                    },
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 10 * SizeConfig.horizontalBlock),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recommended For you",
                  style: TextStyle(
                    fontSize: 20 * SizeConfig.textRatio,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  child: Text(
                    "see more",
                    style: TextStyle(
                      fontSize: 16 * SizeConfig.textRatio,
                      color: SizeConfig.iconColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, browseProducts.id);
                  },
                ),
              ],
            ),
          ),
          Consumer<productProvider>(
            builder: (context, productProvider, child) {
              if (productProvider.products.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: SizeConfig.horizontalBlock,
                  height: 250 * SizeConfig.verticalBlock,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        productProvider.products.length, // Number of items
                    itemBuilder: (context, index) {
                      var product = productProvider.products[index];
                      return Row(
                        children: [
                          customProduct(
                              product.imageURL,
                              product.name,
                              product.category,
                              product.price,
                              product.rate,
                              product.id),
                          SizedBox(width: 10 * SizeConfig.horizontalBlock)
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

class imageProvider extends ChangeNotifier {
  AdvertisementsViewModel AdsVM = AdvertisementsViewModel();

  int _currentIndex = 0;
  Timer? _timer;
  PageController pageController = PageController();

  String get currentImage {
    return AdsVM.ads.isNotEmpty
        ? AdsVM.ads[_currentIndex % AdsVM.ads.length].image
        : 'assets/images/BPM.png'; // Default image
  }

  String get currentLink {
    return AdsVM.ads.isNotEmpty
        ? AdsVM.ads[_currentIndex % AdsVM.ads.length].link
        : 'https://google.com'; // Default link
  }

  imageProvider() {
    AdsVM.fetchAds();
    _startImageRotation();
  }

  void _startImageRotation() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _currentIndex = (_currentIndex + 1) % AdsVM.ads.length;
      pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    });
  }

  void updateCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    pageController.dispose();
    super.dispose();
  }
}
