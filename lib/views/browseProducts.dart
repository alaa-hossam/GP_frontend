import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:gp_frontend/views/compareView.dart';
import 'package:gp_frontend/widgets/HomeBar.dart';
import 'package:gp_frontend/widgets/MyDrawer.dart';
import 'package:provider/provider.dart';
import '../CommomnFunctions/ProfileData.dart';
import '../Models/CategoryModel.dart';
import '../Providers/CategoryProvider.dart';
import '../Providers/ProductProvider.dart';
import '../widgets/Dimensions.dart';
import '../widgets/customProduct.dart';
import '../widgets/customizeCategory.dart';
import '../widgets/customizeTextFormField.dart';

class browseProducts extends StatefulWidget {
  static String id = "browseProductsScreen";

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

    Future.microtask(() {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && mounted) {
        setState(() {
          showCompare = args['showCompare'] ?? false;
        });
      }
    });
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

    print(showCompare);
    SizeConfig().init(context);
    return Scaffold(
      drawer:Mydrawer(),
      appBar: HomeBar(),
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
                      width: 300 * SizeConfig.horizontalBlock,
                      height: 45 * SizeConfig.verticalBlock,
                    ),
                    SizedBox(width: 10 * SizeConfig.horizontalBlock),

                    Container(
                      width: 60 * SizeConfig.horizontalBlock,
                      height: 55 * SizeConfig.verticalBlock,
                      decoration: BoxDecoration(
                        color: showCompare
                            ? SizeConfig.iconColor
                            : Color(0x80E9E9E9),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.compare_outlined,
                            size: 24 * SizeConfig.textRatio , color: showCompare? Colors.white : Colors.black,),
                        onPressed: () {
                          setState(() {
                            showCompare = !showCompare;
                            print(showCompare);
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
    );
  }
}