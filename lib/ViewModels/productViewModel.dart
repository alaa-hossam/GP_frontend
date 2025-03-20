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

  searchProduct(String word){
    return apiServices.searchProduct(word);
  }

  wishProducts(){
    return apiServices.getWishProducts();

  }
  Future<List<productModel>> giftRecommendedProducts(Map<String, String> answers) async {
    try {
      print("Fetching gift recommendations from API...");
      final products = await apiServices.getGifRecommendationProducts(answers);
      print("Gift recommendations fetched successfully: $products");
      return products;
    } catch (e) {
      debugPrint("Error fetching gift recommendations in VM: $e");
      return [];
    }
  }

  Future<String> addProductReview(String comment,String productId,double rate)async{
    return await apiServices.addProductReview(comment, productId, rate);
  }
  cartProducts()async{
    return await  apiServices.getCartProducts();

  }

  productDetails(String productId){
    return apiServices.getProductDetails(productId);
  }
}
