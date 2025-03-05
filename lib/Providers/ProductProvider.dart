import 'package:flutter/cupertino.dart';
import '../Models/ProductModel.dart';
import '../ViewModels/productViewModel.dart';

class productProvider extends ChangeNotifier {
  productViewModel productVM = productViewModel();
  List<productModel> _products = [];

  List<productModel> get products => _products;

  productProvider() {
    print("ProductProvider initialized");
    fetchProducts();
  }

  Future<void> fetchProducts() async{
    print("Fetching products...");
    await productVM.fetchProducts();
    _products = productVM.products.map((product) => product).toList();
    print("products fetched: $_products");
    notifyListeners();
  }

  getSearchProducts(String word){
    productVM.searchProduct(word);
    _products= productVM.products.map((product) =>product).toList();
  }
}
