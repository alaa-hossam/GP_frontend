import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:gp_frontend/Providers/ProductProvider.dart';
import 'package:gp_frontend/ViewModels/productViewModel.dart';
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
  List<dynamic>? products;
  TextEditingController search = TextEditingController();
  Timer? _debounceTimer;

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
      products = await PVM.searchProduct(value);
      setState(() {});
      print("Products:");
      print(products);
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
                        ids = await searchEndPoint.SearchImage(5);
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
                              builder: (context) =>
                                  ProductBottomSheet(products: myProductProvider.searchProducts),
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 5,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Text("The Most Similar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),

          // Use GridView for 2 items per row
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(), // Prevent internal scroll
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.2, // Adjust as needed
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to detail if needed
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name ?? 'Unnamed', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(product.description ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                        Spacer(),
                        Text("${product.price ?? 0} EGP", style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

}
