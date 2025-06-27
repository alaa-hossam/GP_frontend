import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:gp_frontend/Providers/ProductProvider.dart';
import 'package:gp_frontend/ViewModels/productViewModel.dart';
import 'package:gp_frontend/widgets/customProduct.dart';
import 'package:provider/provider.dart';
import '../Models/SearchService.dart';
import '../widgets/Dimensions.dart';
import '../widgets/customizeTextFormField.dart';
import 'dart:async';

class searchView extends StatefulWidget {
  static String id = "searchScreen";

  const searchView({super.key});

  @override
  State<searchView> createState() => _searchState();
}

class _searchState extends State<searchView> {
  late FocusNode _focusNode;
  productViewModel PVM = productViewModel();
  TextEditingController search = TextEditingController();
  Timer? _debounceTimer;
  bool _isBottomSheetOpen = false; // Track state

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    search.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchTextChanged(String value) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (value.trim().isEmpty) return;

      final result = await PVM.searchProduct(value);

      if (context.mounted) {
        if (_isBottomSheetOpen) {
          Navigator.pop(context);
          _isBottomSheetOpen = false;
        }

        if (result != null && result.isNotEmpty) {
          _isBottomSheetOpen = true;

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => ProductBottomSheet(products: result),
          ).whenComplete(() {
            _isBottomSheetOpen = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No products found.")),
          );
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    SearchService searchEndPoint = SearchService();
    List<String> ids = [];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 119 * SizeConfig.verticalBlock,
        flexibleSpace: Container(
          height: 140,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF223F4A),
                Color(0xFF5095B0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: 18.0 * SizeConfig.textRatio),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12 * SizeConfig.textRatio),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10 * SizeConfig.textRatio,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: MyTextFormField(
                    borderRadius: 5 * SizeConfig.textRatio,
                    fillColor: Colors.white,
                    height: 45 * SizeConfig.verticalBlock,
                    width: 336 * SizeConfig.horizontalBlock,
                    controller: search,
                    hintName: "Search",
                    icon: Icons.search,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: SizeConfig.iconColor,
                        size: 24 * SizeConfig.textRatio,
                      ),
                      onPressed: () async {
                        ids = await searchEndPoint.SearchImage(6);
                        if (context.mounted) {
                          final myProductProvider = Provider.of<productProvider>(context, listen: false);
                          await myProductProvider.getSearchProductsImage(ids);

                          if (myProductProvider.searchProducts.isNotEmpty) {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              builder: (context) => ProductBottomSheet(products: myProductProvider.searchProducts),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("No products found.")),
                            );
                          }
                        }
                      },
                    ),
                    onChanged: (value) => _onSearchTextChanged(value.toString()),
                  ),
                ),
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<productProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(child: Text("Search with the camera or type to search."));
          }
        },
      ),
    );
  }
}

class ProductBottomSheet extends StatelessWidget {
  final List<productModel> products;

  const ProductBottomSheet({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.3,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.all(16 * SizeConfig.horizontalBlock),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 60 * SizeConfig.horizontalBlock,
                    height: 5 * SizeConfig.verticalBlock,
                    margin: EdgeInsets.only(bottom: 16 * SizeConfig.verticalBlock),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10 * SizeConfig.textRatio),
                    ),
                  ),
                ),
                Text("The Most Similar", style: TextStyle(fontSize: 18 * SizeConfig.textRatio, fontWeight: FontWeight.bold)),
                SizedBox(height: 16 * SizeConfig.verticalBlock),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: products.map((product) {
                    return customProduct(
                      product.imageURL,
                      product.name,
                      product.price,
                      product.rate,
                      product.id,
                      false,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
