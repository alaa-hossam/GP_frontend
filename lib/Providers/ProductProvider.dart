import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/SqfliteCodes/wishList.dart';
import '../Models/ProductModel.dart';
import '../ViewModels/productViewModel.dart';

class productProvider extends ChangeNotifier {
  productViewModel productVM = productViewModel();
  List<productModel> _products = [];
  List<productModel> get products => _products;
  List<productModel> _giftRecommendProducts = [];
  List<productModel> get giftRecommendProducts => _giftRecommendProducts;
  wishList wishListSql = wishList();
  List<dynamic> wishListProducts = [];
  productModel productDetails = productModel("","", "",0,0);



  productProvider() {
    print("ProductProvider initialized");
  }

  Future<void> fetchProducts(String categoryId) async {
    // print("Fetching products...");
    // print("///////////////////IDddddddd///////////////////////");
    // print(categoryId);
    await productVM.fetchProducts(categoryId);
    _products = productVM.products.map((product) => product).toList();
    // print("Products fetched: $_products");
    notifyListeners();
  }

  Future<void> fetchGiftRecommendProducts(Map<String, String> answers) async {
    try {
      print("Fetching gift recommendations...");
      _giftRecommendProducts = await productVM.giftRecommendedProducts(answers);
      print("Gift recommendations fetched: $_giftRecommendProducts");
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching gift recommendations: $e");
      notifyListeners();
    }
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

  Future<productModel> getProductDetails(String productId)async{
    print("in get product details provider");
    productDetails =await productVM.productDetails(productId);
    return productDetails;
  }






}