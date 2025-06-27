import 'dart:async';
import 'package:gp_frontend/Models/BazarModel.dart';
import 'package:gp_frontend/Providers/AdvertisementProvider.dart';
import 'package:gp_frontend/Providers/BazarProvider.dart';
import 'package:gp_frontend/views/browseProducts.dart';
import 'package:gp_frontend/views/cartView.dart';
import 'package:gp_frontend/views/joinBazar.dart';
import 'package:gp_frontend/views/showBazar.dart';
import 'package:gp_frontend/widgets/MyDrawer.dart';
import 'package:gp_frontend/widgets/customProduct.dart';
import 'package:gp_frontend/widgets/customizeButton.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/views/ProfileView.dart';
import 'package:provider/provider.dart';
import '../Providers/CategoryProvider.dart';
import '../Providers/ProductProvider.dart';
import '../widgets/BottomBar.dart';
import '../widgets/Dimensions.dart';
import '../widgets/customizeTextFormField.dart';
import '../widgets/customizeCategory.dart';
import '../SqfliteCodes/Token.dart';
import 'MyHandcrafterProfile.dart';
import 'SearchView.dart';

class Home extends StatefulWidget {
  static String id = "homeScreen";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController search = TextEditingController();
  int selectedIndex = 0;
  late Future<void> _initialization;
  late Token token;
  late String role;

  @override
  void initState() {
    super.initState();
    _initialization = _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    final catProvider = Provider.of<CategoryProvider>(context, listen: false);
    final productProv = Provider.of<productProvider>(context, listen: false);
    final adsProvider =
        Provider.of<AdvertisementProvider>(context, listen: false);
    final bazarProvider = Provider.of<BazarProvider>(context, listen: false);

    token = Token();
    role = await token.getRole('SELECT ROLE FROM TOKENS');

    await Future.wait<void>([
      catProvider.fetchCategories(),
      productProv.fetchProducts('0'),
      adsProvider.getAdvertisement(),
      bazarProvider.getActiveBazar()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      drawer: Mydrawer(),
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
    final bazarProvider = Provider.of<BazarProvider>(context);

    return ListView(
      children: [
        _buildSearchBar(),
        SizedBox(height: 10),
        _buildAdsSection(adsProvider, bazarProvider),
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
              onClickFunction : () {Navigator.pushNamed(context, searchView.id)},

              controller: search,
              hintName: "Search",
              icon: Icons.search,
              suffixIcon: IconButton(
                icon: Icon(Icons.camera_alt_outlined),
                onPressed: () {
                  Navigator.pushNamed(context, searchView.id);
                },
              ),
              // onClickFunction:(context) => _navigateToSearch(),
            ),
          ),
          SizedBox(width: 10),
          Icon(Icons.tune),
        ],
      ),
    );
  }

  Widget _buildAdsSection(AdvertisementProvider provider, BazarProvider bazar) {
    final hasBazar = bazar.activeBazar.id != null;
    final totalItems = provider.ads.length + (hasBazar ? 1 : 0);

    return Column(
      children: [
        SizedBox(
          height: 160 * SizeConfig.verticalBlock,
          child: PageView.builder(
            controller: provider.pageController,
            itemCount: totalItems,
            onPageChanged: provider.updateCurrentIndex,
            itemBuilder: (context, index) {
              if (hasBazar && index == 0) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.0 * SizeConfig.horizontalBlock),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(
                            Radius.circular(10 * SizeConfig.horizontalBlock)),
                        child: Image.asset(
                          "assets/images/bazar.png",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          children: [
                            customizeButton(
                              buttonName: "Open",
                              buttonColor: SizeConfig.secondColor,
                              fontColor: Colors.white,
                              height: 35 * SizeConfig.verticalBlock,
                              width: 70 * SizeConfig.horizontalBlock,
                              onClickButton: () => {
                                Navigator.pushNamed(context, showBazar.id,
                                    arguments: bazar.activeBazar.id)
                              },
                            ),
                            SizedBox(
                              width: 20 * SizeConfig.horizontalBlock,
                            ),
                            if (role == 'Handicrafter')
                              customizeButton(
                                buttonName: "Join",
                                buttonColor: SizeConfig.secondColor,
                                fontColor: Colors.white,
                                height: 35 * SizeConfig.verticalBlock,
                                width: 70 * SizeConfig.horizontalBlock,
                                onClickButton: () =>
                                    Navigator.pushNamed(context, JoinBazar.id),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              final adIndex = hasBazar ? index - 1 : index;

              if (provider.ads.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final ad = provider.ads[adIndex];

              return Padding(
                padding: EdgeInsets.only(
                    left: 10.0 * SizeConfig.horizontalBlock,
                    right: 10 * SizeConfig.horizontalBlock),
                child: GestureDetector(
                  onTap: () async {
                    final url = Uri.parse(ad.link!);
                    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
                      throw 'Could not launch ${ad.link}';
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                        Radius.circular(10 * SizeConfig.horizontalBlock)),
                    child: Image.network(
                      ad.imageUrl ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // 🟣 Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            totalItems,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == provider.currentIndex
                    ? const Color(0xFFB36995)
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
      height: 43 * SizeConfig.verticalBlock,
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
          if (products.isEmpty) {
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
