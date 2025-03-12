import 'package:flutter/cupertino.dart';

import '../Models/ProductModel.dart';

class productViewModel  extends ChangeNotifier{
  final productService apiServices = productService();
  List<productModel> _products = [];
  List<productModel> get products => _products;

  Future<void> fetchProducts(String categoryId) async {
    try {
      print("Fetching products from API...");
      _products = await apiServices.getAllProducts(categoryId);
      print("Products fetched successfully: $_products");
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching products in VM: $e");
      notifyListeners();
    }
  }
  // Future<void> fetchProductsByCategory(String categoryId) async{
  //   try {
  //     print("Fetching products category from API...");
  //     _productsCategory = await apiServices.getAllProductsByCategory(categoryId);
  //     print("products category fetched successfully: $_productsCategory");
  //     notifyListeners();
  //   } catch (e) {
  //     debugPrint("Error fetching products category in VM: $e");
  //     notifyListeners();
  //   }
  // }
  //
  searchProduct(String word){
    return apiServices.searchProduct(word);
  }

  wishProducts(){
    return apiServices.getWishProducts();

  }

  productDetails(String productId){
    return apiServices.getProductDetails(productId);
  }
}
