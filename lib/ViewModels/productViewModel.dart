import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/Models/SearchModel.dart';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:gp_frontend/SqfliteCodes/cart.dart';

import '../Models/ProductModel.dart';

class productViewModel extends ChangeNotifier {
  final productService apiServices = productService();
  List<productModel> _products = [];
  List<productModel> get products => _products;
  List<productModel> _recommendProducts = [];
  List<productModel> get recommendProducts => _recommendProducts;
  Cart myCart = Cart();

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

  Future<void> recommendProductsForUser() async {
    try {
      _recommendProducts = await apiServices.getRecommendProducts();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching products in VM: $e");
      notifyListeners();
    }
  }

  Future<productModel> addProduct({
    required String categoryId,
    required String name,
    required String description,
    required List<String> indicatorIds,
    required List<Map<String, dynamic>> variations,
    required File imageFile,
  }) async {
    try {
      print("Calling addProduct in ViewModel...");
      final result = await apiServices.addProduct(
        categoryId: categoryId,
        name: name,
        description: description,
        indicatorIds: indicatorIds,
        variations: variations,
        imageFile: imageFile,
      );
      print("Product creation result: $result");
      return result;
    } catch (e) {
      debugPrint("Error in ViewModel addProduct: $e");
      rethrow;
    }
  }

  Future<String> addFinalProduct({
    required String productId,
    int? duration, // made optional
    int? stockquntity, // made optional
    required bool isCustom,
    required double price,
    required List<String> varitionIds,
    required List<File> galleryImages,
    required File imageFile,
  }) async {
    try {
      debugPrint("Calling addFinalProduct in ViewModel...");

      final result = await apiServices.addFinalProduct(
        productId: productId,
        duration: duration, // can be null
        stockquntity: stockquntity, // can be null
        isCustom: isCustom,
        price: price,
        varitionIds: varitionIds,
        galleryImages: galleryImages,
        imageFile: imageFile,
      );

      debugPrint("Product creation result: $result");
      return result;
    } catch (e) {
      debugPrint("Error in ViewModel addFinalProduct: $e");
      rethrow;
    }
  }


  wishProducts() {
    return apiServices.getWishProducts();
  }

  Future<List<productModel>> giftRecommendedProducts(
      Map<String, String> answers) async {
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

  Future<List<productModel>> historyProducts() async {
    try {
      print("Fetching history products from API in VM...");
      final products = await apiServices.HistoryProducts();
      print("history productsfetched successfully: $products");
      return products;
    } catch (e) {
      debugPrint("Error fetching history products in VM: $e");
      return [];
    }
  }

  Future<String> addProductReview(
      String comment, String productId, double rate) async {
    return await apiServices.addProductReview(comment, productId, rate);
  }

  cartProducts() async {
    return await apiServices.getCartProducts();
  }

  deleteCartProduct(String finalId) async {
    Token token = Token();
    String id = await token.getUUID() ?? "";
    return await myCart.deleteProduct(finalId, id);
  }

  productDetails(String productId) {
    return apiServices.getProductDetails(productId);
  }

  handCrafterProducts() {
    return apiServices.getHandcrafterProduct();
  }

  handCrafterProductsByID(String crafterId) {
    return apiServices.getHandcrafterProductById(crafterId);
  }

  productVariation(List<String> productIds) {
    return apiServices.getAddedProducts(productIds);
  }

  getFinalProductVariations(String productId) {
    return apiServices.getFinalProductVariations(productId);
  }

  Future<bool> checkCustom(List<String> ids) async {
    return await apiServices.getproductType(ids);
  }
}
