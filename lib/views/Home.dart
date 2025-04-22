import 'dart:async';
import 'package:gp_frontend/Providers/AdvertisementProvider.dart';
import 'package:gp_frontend/SqfliteCodes/wishList.dart';
import 'package:gp_frontend/views/HandcrafterRequest.dart';
import 'package:gp_frontend/views/RecommendGiftView.dart';
import 'package:gp_frontend/views/browseProducts.dart';
import 'package:gp_frontend/views/cartView.dart';
import 'package:gp_frontend/views/eventsView.dart';
import 'package:gp_frontend/views/joinBazar.dart';
import 'package:gp_frontend/views/logInView.dart';
import 'package:gp_frontend/views/showBazar.dart';
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
import 'AddAdvertisement.dart';
import 'MyHandcrafterProfile.dart';
import 'SearchView.dart';
import 'historyView.dart';

class Home extends StatefulWidget {
  static String id = "homeScreen";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController search = TextEditingController();
  int selectedIndex = 0;
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    final catProvider = Provider.of<CategoryProvider>(context, listen: false);
    final productProv = Provider.of<productProvider>(context, listen: false);
    final adsProvider = Provider.of<AdvertisementProvider>(context, listen: false);

    await Future.wait<void>([
      catProvider.fetchCategories(),
      productProv.fetchProducts('0'),
      adsProvider.getAdvertisement(),
    ]);

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      drawer: _buildDrawer(),
      appBar: _buildAppBar(context),
      body: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return _buildHomeContent();
        },
      ),
      bottomNavigationBar: BottomBar(selectedIndex: 0, isVisible: true),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      width: 223 * SizeConfig.horizontalBlock,
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          ListView(
            children: [
              _buildDrawerHeader(),
              Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
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
                          Navigator.pushNamed(context, JoinBazar.id);
                        }),
                    sideButton("History", Icons.history_outlined,
                        SizeConfig.iconColor, () {
                          Navigator.pushNamed(context, HistoryProducts.id);
                        }),
                    sideButton("My posts", Icons.post_add, SizeConfig.iconColor,
                            () {
                          Navigator.pushNamed(context, showBazar.id);
                        }),
                    sideButton("Compare Products", Icons.compare_outlined,
                        SizeConfig.iconColor, () {
                          Navigator.pushNamed(context, Profile.id);
                        }),
                    sideButton("Recommend Gifts", Icons.card_giftcard_outlined,
                        SizeConfig.iconColor, () {
                          Navigator.pushNamed(context, RecommendGift.id);
                        }),
                    sideButton("Event Reminder", Icons.event_available_outlined,
                        SizeConfig.iconColor, () {
                          Navigator.pushNamed(context, EventsView.id);
                        }),
                    sideButton("Add Advertisement", Icons.camera_roll_outlined,
                        SizeConfig.iconColor, () {
                          Navigator.pushNamed(context, Addadvertisement.id);
                        }),
                    sideButton("Join as Handcrafter", Icons.shopping_bag_outlined,
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
            child: sideButton("Log Out", Icons.logout_outlined, Colors.red, () {
              Navigator.pushReplacementNamed(context, logIn.id);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Stack(
      children: [
        Container(
          color: const Color(0xFFE9E9E9),
          height: 251 * SizeConfig.verticalBlock,
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
                  border: Border.all(color: Color(0xFF5095B0), width: 3),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/p1.jpg'),
                ),
              ),
              Text("my name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text("myemail@gmail.com", style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications_none, size: 24),
        ),
        IconButton(
          onPressed: () => Navigator.pushNamed(context, cartScreen.id),
          icon: Icon(Icons.shopping_cart_outlined, size: 24),
        ),
        IconButton(
          onPressed: () async {
            // Fetch the user's role from the database or token
            final token = Token();
            final role = await token.getRole('SELECT ROLE FROM TOKENS');
print(role);
            // Navigate to the appropriate profile based on the role
            if (role == 'Handicrafter') {
              Navigator.pushNamed(context, MyHandcrafterProfile.id);
            } else if (role == 'Client') {
              Navigator.pushNamed(context, Profile.id);
            }
          },
          icon: Icon(Icons.account_circle_outlined, size: 24),
        ),
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/Frame 36920.png", width: 40, height: 40),
          Text(
            "SAN3A",
            style: TextStyle(
              color: Color(0xFF073477),
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontFamily: 'Poppins',
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildHomeContent() {
    final adsProvider = Provider.of<AdvertisementProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final productProv = Provider.of<productProvider>(context);

    return ListView(
      children: [
        _buildSearchBar(),
        SizedBox(height: 10),
        _buildAdsSection(adsProvider),
        SizedBox(height: 10),
        _buildCategories(categoryProvider),
        SizedBox(height: 10),
        _buildSectionTitle("Best Seller"),
        _buildProductList(productProv.products),
        _buildSectionHeader("Recommended For You", onTap: () {
          Navigator.pushNamed(context, browseProducts.id);
        }),
        _buildProductList(productProv.products),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextFormField(
              controller: search,
              hintName: "Search",
              icon: Icons.search,
              suffixIcon: IconButton(
                icon: Icon(Icons.camera_alt_outlined),
                onPressed: () {Navigator.pushNamed(context, searchView.id);},
              ),
              // onClickFunction:(context) => _navigateToSearch(),
            ),
          ),
          SizedBox(width: 10),
          Icon(Icons.tune),
          SizedBox(width: 10),
          Icon(Icons.compare_outlined),
        ],
      ),
    );
  }

  Widget _buildAdsSection(AdvertisementProvider provider) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: provider.pageController,
            itemCount: provider.ads.length,
            onPageChanged: provider.updateCurrentIndex,
            itemBuilder: (context, index) {
              final ad = provider.ads[index];
              if(provider.ads.isEmpty){
                return const Center(child: CircularProgressIndicator());

              }
              return Padding(
                padding:  EdgeInsets.only(left: 10.0 * SizeConfig.horizontalBlock , right: 10* SizeConfig.horizontalBlock),
                child: GestureDetector(

                  onTap: () async {
                    final url = Uri.parse(ad.link!);
                    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
                      throw 'Could not launch ${ad.link}';
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10 * SizeConfig.horizontalBlock)),
                    child: Image.network(

                        ad.imageUrl ?? '', fit: BoxFit.cover
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            provider.ads.length,
                (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == provider.currentIndex
                    ? Color(0xFFB36995)
                    : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategories(CategoryProvider provider) {
    return SizedBox(
      height: 43,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: provider.categories.length,
        itemBuilder: (context, index) {
          final category = provider.categories[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Customizecategory(category.name, index == selectedIndex),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: Text("See more", style: TextStyle(color: Colors.blue)),
            ),
        ],
      ),
    );
  }

  Widget _buildProductList(List<dynamic> products) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          if(products.isEmpty){
            return const Center(child: CircularProgressIndicator());

          }
          return Row(
            children: [
              customProduct(
                product.imageURL,
                product.name,
                product.price,
                product.rate,
                product.id,
                Category: product.category,
                false,
              ),
              SizedBox(width: 10),
            ],
          );
        },
      ),
    );
  }
}

