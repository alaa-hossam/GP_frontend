import 'package:flutter/cupertino.dart';

import '../Models/ProductModel.dart';
import '../ViewModels/productViewModel.dart';

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

  getSearchProducts(String word){
    productVM.searchProduct(word);
    _products= productVM.products.map((product) =>product).toList();
  }
}
