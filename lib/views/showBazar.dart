import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/views/Home.dart';
import 'package:provider/provider.dart';

import '../Models/CategoryModel.dart';
import '../Models/ProductModel.dart';
import '../Providers/BazarProvider.dart';
import '../Providers/CategoryProvider.dart';
import '../Providers/ProductProvider.dart';
import '../SqfliteCodes/Token.dart';
import '../widgets/BottomBar.dart';
import '../widgets/Dimensions.dart';
import '../widgets/MyDrawer.dart';
import '../widgets/customProduct.dart';
import '../widgets/customizeCategory.dart';
import '../widgets/customizeTextFormField.dart';
import 'MyHandcrafterProfile.dart';
import 'ProfileView.dart';
import 'cartView.dart';

class showBazar extends StatefulWidget {
  static String id = "showBazar";
  const showBazar({super.key});

  @override
  State<showBazar> createState() => _showBazarState();
}

class _showBazarState extends State<showBazar> {
  TextEditingController search = TextEditingController();
  int selectedIndex = 0;
  int selectedChildIndex = 0;
  List<productModel> comparedProducts = [];
  late productProvider prodProvider;
  late CategoryProvider catProvider;
  late BazarProvider bazarProvider;
  String? selectedCategoryId;
  List<CategoryModel> categoryChildren = [];
  bool isLoading = false;
  late Token token;
  late String role;
  String? bazarId;
  bool _hasInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) {
        bazarId = args;
        bazarProvider = Provider.of<BazarProvider>(context, listen: false);
        bazarProvider.bazarProducts.clear();
        bazarProvider.getBazarProducts(bazarId!);
      }
      catProvider = Provider.of<CategoryProvider>(context, listen: false);
      catProvider.fetchCategories();
      _fetchInitialData();
      _hasInitialized = true;
    }
  }

  Future<void> _fetchInitialData() async {
    token = Token();
    role = await token.getRole('SELECT ROLE FROM TOKENS');
  }

  Future<void> _handleCategorySelection(CategoryModel category) async {
    setState(() {
      selectedIndex = catProvider.categories.indexOf(category);
      selectedCategoryId = category.id;
      isLoading = true;
      selectedChildIndex = 0;
    });

    await catProvider.fetchCategoryChildren(category.id);
    await prodProvider.fetchProducts(selectedCategoryId!);

    setState(() {
      categoryChildren = catProvider.categoryCildren;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 371 * SizeConfig.horizontalBlock,
                  height: 46 * SizeConfig.verticalBlock,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF223F4A), Color(0xFF5095B0)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(5 * SizeConfig.textRatio)),
                  ),
                  child: Center(
                    child: Text(
                      "Welcome to our bazar",
                      style: GoogleFonts.rubik(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10 * SizeConfig.verticalBlock),
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
                      width: 263 * SizeConfig.horizontalBlock,
                      height: 35 * SizeConfig.verticalBlock,
                    ),
                    SizedBox(width: 10 * SizeConfig.horizontalBlock),
                    Container(
                      width: 58 * SizeConfig.horizontalBlock,
                      height: 55 * SizeConfig.verticalBlock,
                      decoration: BoxDecoration(
                        color: Color(0x80E9E9E9),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(Icons.tune, size: 24 * SizeConfig.textRatio),
                    ),
                    SizedBox(width: 10 * SizeConfig.horizontalBlock),
                  ],
                ),
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
                if (categoryChildren.isNotEmpty)
                  Consumer<CategoryProvider>(
                    builder: (context, catProvider, child) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 43 * SizeConfig.verticalBlock,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: catProvider.categoryCildren.length,
                            itemBuilder: (context, index) {
                              bool isSelected = selectedChildIndex == index;
                              var category = catProvider.categoryCildren[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedChildIndex = index;
                                    _handleCategorySelection(category);
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
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else
                  Consumer<BazarProvider>(
                    builder: (context, bazarProvider, child) {
                      if (bazarProvider.bazarProducts.isEmpty) {
                        return Center(child: Text("No products available"));
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: bazarProvider.bazarProducts.length,
                          itemBuilder: (context, index) {
                            var product = bazarProvider.bazarProducts[index];
                            return customProduct(
                              product.imageURL,
                              product.name,
                              Category: product.category,
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
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: 0,
        isVisible: false,
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
          onPressed: () => Navigator.pushReplacementNamed(context, Home.id),
          icon: Icon(Icons.arrow_back)),
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
            if (role == 'Handicrafter') {
              Navigator.pushNamed(context, MyHandcrafterProfile.id);
            } else {
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
}
