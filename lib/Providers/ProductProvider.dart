import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/SqfliteCodes/wishList.dart';
import '../Models/ProductModel.dart';
import '../ViewModels/productViewModel.dart';

class productProvider extends ChangeNotifier {
  productViewModel productVM = productViewModel();
  List<productModel> _products = [];
  List<productModel> get products => _products;
  wishList wishListSql = wishList();
  List<dynamic> wishListProducts = [];

  productProvider() {
    print("ProductProvider initialized");
    fetchProducts();
  }




  Future<void> fetchProducts() async {
    print("Fetching products...");
    await productVM.fetchProducts();
    _products = productVM.products.map((product) => product).toList();
    print("products fetched allllllllll: $_products");
    notifyListeners();
  }

  getSearchProducts(String word) {
    productVM.searchProduct(word);
    _products = productVM.products.map((product) => product).toList();
  }

  // Make this method async and await the result
  Future<void> getWishProducts() async {

    wishListProducts = await productVM.wishProducts();
    print("inside provider");
    print(wishListProducts);
    notifyListeners(); // Notify listeners after updating the data
  }
  Future<void> deleteProduct(String id) async {
    // Delete the product from the database
    await wishList().deleteProduct('''
      DELETE FROM wishList 
      WHERE ID = '$id'
    ''');

    // Remove the product from the wishListProducts list
    wishListProducts.removeWhere((product) => product.id == id);
    // Notify listeners to rebuild the UI
    notifyListeners();
  }
}