import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/Models/SearchModel.dart';
import 'package:gp_frontend/Providers/ProductProvider.dart';
import 'package:gp_frontend/Providers/SearchProvider.dart';
import 'package:gp_frontend/ViewModels/SearchViewModel.dart';
import 'package:gp_frontend/ViewModels/productViewModel.dart';
import 'package:gp_frontend/widgets/customProduct.dart';
import 'package:image_picker/image_picker.dart';
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
  SearchViewModel SVM = SearchViewModel();
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


  Future<void> _handleImageSearch(SearchServiceAI service, ImageSource source) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      List<String> ids = await service.searchImage(6, source: source);

      if (!mounted) return;

      final mySearchProvider = Provider.of<SearchProvider>(context, listen: false);
      await mySearchProvider.getSearchProductsImage(ids);

      // Dismiss loading indicator
      if (mounted) Navigator.pop(context);

      if (mySearchProvider.searchProducts.isNotEmpty) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => ProductBottomSheet(products: mySearchProvider.searchProducts),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No products found.")),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Dismiss loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error searching image.")),
      );
    }
  }


  void _showImageSourceDialog(BuildContext context, SearchServiceAI service) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text("Take Photo"),
              onTap: () async {
                Navigator.pop(context);
                await _handleImageSearch(service, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () async {
                Navigator.pop(context);
                await _handleImageSearch(service, ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }



  void _onSearchTextChanged(String value) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (value.trim().isEmpty) return;

      final result = await SVM.searchProduct(value);

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
    SearchServiceAI searchEndPoint = SearchServiceAI();
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
                        _showImageSourceDialog(context, searchEndPoint);
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
  final List<SearchModel> products;

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
                      product.imageUrl ?? "",
                      product.name ?? "",
                      product.lowestCustomPrice ?? 0,
                      product.averageRating ?? 0,
                      product.id ?? "",
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




