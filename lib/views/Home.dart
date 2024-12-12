import 'dart:async';
import 'package:gp_frontend/ViewModels/CategoryViewModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/ViewModels/AdvertisementsViewModel.dart';
import 'package:gp_frontend/views/ProfileView.dart';
import 'package:provider/provider.dart';
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
  int selectedIndex = -1;

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
                ),
                SizedBox(
                  width: 10 * SizeConfig.horizontalBlock,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Profile.id);
                  },
                  icon: Icon(Icons.account_circle_outlined),
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
                  ),
                  onPressed: () {},
                ),
                width: 300 - (10 * SizeConfig.horizontalBlock),
                height: 45,
              ),
              SizedBox(width: 20 * SizeConfig.horizontalBlock),
              MyTextFormField(
                controller: filter,
                icon: Icons.tune,
                width: 48 - (10 * SizeConfig.horizontalBlock),
                height: 45,
              )
            ],
          ),
          SizedBox(
            height: 10 * SizeConfig.verticalBlock,
          ),
          Consumer<imageProvider>(
            builder: (context, imageProvider, child) {
              return Column(
                children: [
                  GestureDetector(
                      onTap: () async {
                        final Uri url = Uri.parse(imageProvider.currentLink);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.inAppWebView);
                        } else {
                          throw 'Could not launch ${imageProvider.currentLink}';
                        }
                      },
                      child: Image.asset(
                        imageProvider.currentImage,
                        width: 363,
                        height: 160,
                        fit: BoxFit.fill,
                      )),
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
                                      ? Color(0xFFB36995) // Highlighted color
                                      : Colors.grey, // Default color
                                ),
                              )))
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
                    itemCount: categoryProvider.categories.length, // Number of items
                    itemBuilder: (context, index) {
                      bool isSelected = index == selectedIndex;
                      var category = categoryProvider.categories[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index; // Update the selected index
                          });
                        },
                        child: Row(
                          children: [
                            Customizecategory("${category}", isSelected)
                          ],
                        )
                      );
                      // if (index == 0) {
                      //   return Row(
                      //     children: [
                      //       Customizecategory("All"),
                      //       Customizecategory("${category}")
                      //     ],
                      //   );
                      // } else {
                      //   return Customizecategory("${category}");
                      // }
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

  String get currentImage {
    return AdsVM.ads.isNotEmpty
        ? AdsVM.ads[_currentIndex % AdsVM.ads.length]
            .image // Access the File's path
        : 'assets/images/BPM.png'; // Default image
  }

  String get currentLink {
    return AdsVM.ads.isNotEmpty
        ? AdsVM.ads[_currentIndex % AdsVM.ads.length]
            .link // Access the File's path
        : 'https://google.com'; // Default image
  }

  imageProvider() {
    AdsVM.fetchAds();
    _startImageRotation();
  }

  void _startImageRotation() {
    AdsVM.fetchAds();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _currentIndex = (_currentIndex + 1) % AdsVM.ads.length;

      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
    print("Fetching categories...");
    CatVM.fetchCats();
    print("Fetched categories: ${CatVM.categories}");

    _categories = CatVM.categories.map((cat) => cat.name).toList();
    print("Processed categories: $categories");

    notifyListeners();
  }
}
