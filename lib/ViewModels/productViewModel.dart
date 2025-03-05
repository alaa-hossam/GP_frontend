import 'package:flutter/cupertino.dart';

import '../Models/ProductModel.dart';

class productViewModel  extends ChangeNotifier{
  final productService apiServices = productService();
  List<productModel> _products = [];

  List<productModel> get products => _products;

  Future<void> fetchProducts() async{
    try {
      print("Fetching products from API...");
      _products = await apiServices.getAllProducts();
      print("products fetched successfully: $_products");
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching products in VM: $e");
      notifyListeners();
    }
  }

  searchProduct(String word){
    return apiServices.searchProduct(word);
  }
}