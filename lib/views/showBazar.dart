import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/views/Home.dart';
import 'package:gp_frontend/widgets/BazarProduct.dart';
import 'package:gp_frontend/widgets/customizeButton.dart';
import 'package:provider/provider.dart';
import '../CommomnFunctions/ProfileData.dart';
import '../Models/CategoryModel.dart';
import '../Models/ProductModel.dart';
import '../Providers/BazarProvider.dart';
import '../Providers/CategoryProvider.dart';
import '../Providers/ProductProvider.dart';
import '../SqfliteCodes/Token.dart';
import '../widgets/Dimensions.dart';
import '../widgets/customizeCategory.dart';
import '../widgets/customizeTextFormField.dart';
import '../widgets/messages.dart';
import 'MyHandcrafterProfile.dart';
import 'cartView.dart';
import 'checkOut.dart';

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
  Map<productModel, int> selectedProducts = {};


  double calculateTotalPrice(Map<productModel, int> selectedProducts) {
    double total = 0.0;

    selectedProducts.forEach((product, quantity) {
      double price = product.price ?? 0;
      total += price * quantity;
    });

    return total;
  }


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
    role = await token.getRole()?? "";
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
                      Radius.circular(5 * SizeConfig.textRatio),
                    ),
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
                      if (bazarProvider.loading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (bazarProvider.bazarProducts.isEmpty) {
                        return Center(child: Text("No products available"));
                      }
                      return GridView.builder(
                        padding: EdgeInsets.all(8 * SizeConfig.verticalBlock),
                        shrinkWrap: true,
                        physics:
                            NeverScrollableScrollPhysics(), // Prevents nested scroll conflict
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.68,
                        ),
                        itemCount: bazarProvider.bazarProducts.length,
                        itemBuilder: (context, index) {
                          var product = bazarProvider.bazarProducts[index];
                          return BazarProduct(
                            product: product,
                            onAddProduct: () {
                              setState(() {
                                if (product.custom) {
                                  if (selectedProducts.isNotEmpty) {
                                    if (selectedProducts.containsKey(product)) {
                                      selectedProducts[product] =
                                          selectedProducts[product]! + 1;
                                    } else {
                                      showCustomPopup(
                                          context,
                                          "Take Care",
                                          "Cart Have One Or More Custom Product You Should Order Only One Type(Custom , Ready)",
                                          []);
                                    }
                                  } else {
                                    selectedProducts[product] = 1;
                                  }
                                } else {
                                  if (selectedProducts.containsKey(product)) {
                                    selectedProducts[product] =
                                        selectedProducts[product]! + 1;
                                  } else {
                                    selectedProducts[product] = 1;
                                  }
                                }
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                if (selectedProducts.isNotEmpty)
                  Column(
                    children: [
                      Container(
                        height: 120,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedProducts.length,
                          itemBuilder: (context, index) {
                            final entry =
                                selectedProducts.entries.elementAt(index);
                            final product = entry.key;
                            final quantity = entry.value;

                            return Container(
                              width: 100,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(product.imageURL),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.4),
                                      BlendMode.darken),
                                ),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: 5,
                                    left: 5,
                                    child: Text(
                                      product.name,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: IconButton(
                                      icon: Icon(Icons.remove_circle,
                                          color: Colors.red, size: 20),
                                      onPressed: () {
                                        setState(() {
                                          if (quantity > 1) {
                                            selectedProducts[product] =
                                                quantity - 1;
                                          } else {
                                            selectedProducts.remove(product);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 5,
                                    right: 5,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'x$quantity',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      customizeButton(
                          buttonName: "Check Out",
                          buttonColor: SizeConfig.iconColor,
                          fontColor: Colors.white,
                          onClickButton: () {
                            List<Map<String, dynamic>> productsToSend = selectedProducts.entries.map((entry) => {
                              'productId': entry.key.id,
                              'finalId': entry.key.finalId ?? '',
                              'quantity': entry.value,
                              'product': entry.key,
                            }).toList();

                            Navigator.pushNamed(
                              context,
                              checkOut.id,
                              arguments: {
                                'price': calculateTotalPrice(selectedProducts),
                                'products': productsToSend,
                                'bazar': true,
                                'custom':selectedProducts.entries.first.key.custom
                              },
                            );
                          }

                      )
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),

    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.pushReplacementNamed(context, Home.id),
        icon: Icon(Icons.arrow_back),
      ),
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
              loadProfileByRole(
                context: context,
                onCustomerLoaded: (customer) {
                  print("Customer loaded: ${customer.name}");
                },
                onCrafterLoaded: (crafter) {
                  print("Crafter loaded: ${crafter.name}");
                },
              );
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
