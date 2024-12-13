import 'dart:async';
import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:gp_frontend/ViewModels/CategoryViewModel.dart';
import 'package:gp_frontend/widgets/customProduct.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/ViewModels/AdvertisementsViewModel.dart';
import 'package:gp_frontend/views/ProfileView.dart';
import 'package:provider/provider.dart';
import '../ViewModels/productViewModel.dart';
import '../widgets/BottomBar.dart';
import '../widgets/Dimensions.dart';
import '../widgets/customizeTextFormField.dart';
import '../widgets/customizeCategory.dart';

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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,

      ),
      appBar: AppBar(
        // leading: Icon(Icons.menu),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20 * SizeConfig.verticalBlock),
            child: Row(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size:24 * SizeConfig.textRatio,
                ),
                SizedBox(
                  width: 10 * SizeConfig.horizontalBlock,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Profile.id);
                  },
                  icon: Icon(Icons.account_circle_outlined, size:24 * SizeConfig.textRatio,),
                ),
              ],
            ),
          )
        ],
        title: Text("Logo"),
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
                    Icons.qr_code_scanner_outlined,
                    color: SizeConfig.iconColor,
                    size: 24 * SizeConfig.textRatio,
                  ),
                  onPressed: () {},
                ),
                width: 300 * SizeConfig.horizontalBlock,
                height: 45 * SizeConfig.verticalBlock,
              ),
              SizedBox(width: 20 * SizeConfig.horizontalBlock),
              Container(
                width:48 * SizeConfig.horizontalBlock,
                height: 45 * SizeConfig.verticalBlock,
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: Icon(Icons.tune , size: 24 * SizeConfig.textRatio,),
              ),
              // MyTextFormField(
              //   controller: filter,
              //   icon: Icons.tune,
              //   width: 48 * SizeConfig.horizontalBlock,
              //   height: 45 * SizeConfig.verticalBlock,
              // )
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
                        imageProvider.updateCurrentIndex(index); // Sync current index
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            final Uri url = Uri.parse(imageProvider.AdsVM.ads[index].link);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url, mode: LaunchMode.inAppWebView);
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
              if (categoryProvider._categories.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              // return Text('${categoryProvider.categories.length}');
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: SizeConfig.horizontalBlock,
                  height: 43 * SizeConfig.verticalBlock,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        categoryProvider.categories.length, // Number of items
                    itemBuilder: (context, index) {
                      bool isSelected = index == selectedIndex;
                      var category = categoryProvider.categories[index];
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex =
                                  index; // Update the selected index
                            });
                          },
                          child: Row(
                            children: [
                              Customizecategory("${category}", isSelected)
                            ],
                          ));
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
                // print(productProvider.products.length);
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
                          customProduct(product.imageURL, product.name,
                              product.category, product.price, product.rate),
                          SizedBox(width: 10 * SizeConfig.horizontalBlock)
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 10 * SizeConfig.horizontalBlock),
            child: Text(
              "Recommended For you",
              style: TextStyle(
                  fontSize: 20 * SizeConfig.textRatio,
                  fontWeight: FontWeight.bold),
            ),
          ),


          Consumer<productProvider>(
            builder: (context, productProvider, child) {
              if (productProvider.products.isEmpty) {
                // print(productProvider.products.length);
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
                          customProduct(product.imageURL, product.name,
                              product.category, product.price, product.rate),
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

class CategoryProvider extends ChangeNotifier {
  CategoryViewModel CatVM = CategoryViewModel();
  List<String> _categories = [];

  List<String> get categories => _categories;

  CategoryProvider() {
    fetchCategories();
  }

  void fetchCategories() {
    CatVM.fetchCats();
    _categories = CatVM.categories.map((cat) => cat.name).toList();
    notifyListeners();
  }
}

class productProvider extends ChangeNotifier {
  productViewModel productVM = productViewModel();
  List<productModel> _products = [];

  List<productModel> get products => _products;

  productProvider() {
    fetchProducts();
  }

  void fetchProducts() {
    productVM.fetchProducts();
    _products = productVM.products.map((product) => product).toList();
    notifyListeners();
  }
}
