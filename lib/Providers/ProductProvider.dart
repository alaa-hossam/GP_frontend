import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/SqfliteCodes/cart.dart';
import 'package:gp_frontend/SqfliteCodes/wishList.dart';
import '../Models/ProductModel.dart';
import '../SqfliteCodes/Token.dart';
import '../ViewModels/productViewModel.dart';

class productProvider extends ChangeNotifier {
  productViewModel productVM = productViewModel();
  List<productModel> _products = [] , handCrafterProducts = [] , _recomendedProducts = [];
  List<productModel> get products => _products;
  List<productModel> get recomendedProducts => _recomendedProducts;
  List<productModel> _giftRecommendProducts = [];
  List<productModel> get giftRecommendProducts => _giftRecommendProducts;
  List<productModel> _historyProducts = [];
  List<productModel> get historyProducts => _historyProducts;

  wishList wishListSql = wishList();
  List<dynamic> wishListProducts = [];
  productModel productDetails = productModel("","", "",0,0);
  final wishList _wishListObj = wishList();
  final Token token = Token();
  Set<String> _wishlistItems = {};

  bool loading = false;

  productProvider() {
    print("ProductProvider initialized");
  }

  Future<void> fetchProducts(String categoryId) async {
    await productVM.fetchProducts(categoryId);
    _products = productVM.products.map((product) => product).toList();
    notifyListeners();
  }
  Future<void> recommendProductsForUser() async {
    await productVM.recommendProductsForUser();
    _recomendedProducts = productVM.recommendProducts.map((product) => product).toList();
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
  Future<void> fetchHistoryProducts() async {
    try {
      print("Fetching history products...");
      _historyProducts = await productVM.historyProducts();
      print("history products fetched: $_historyProducts");
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching history products: $e");
      notifyListeners();
    }
  }





  WishlistProvider() {
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    _wishlistItems = Set<String>.from(await wishListSql.getProductIdsByEmail('SELECT ID FROM WISHLIST'));
  }

  bool isFavorite(String productId) {
    return _wishlistItems.contains(productId);
  }

  Future<void> toggleFavorite(String productId) async {
    final email = await token.getEmail() ?? "";
    final id = await token.getUUID() ?? "";

    if (_wishlistItems.contains(productId)) {
      await _wishListObj.deleteProduct(id , email);
      _wishlistItems.remove(productId);
    } else {
      await _wishListObj.addProduct(id: id , email: email);
      _wishlistItems.add(productId);
    }
    notifyListeners();
  }
  Future<void> getWishProducts() async {

    wishListProducts = await productVM.wishProducts();
    notifyListeners(); // Notify listeners after updating the data
  }

  void clearWishProducts() {
    wishListProducts.clear();
    notifyListeners();
  }


  Future<void> deleteProduct(String productId) async {
    String email = await token.getEmail() ?? "";

    await wishList().deleteProduct(productId, email);
    wishListProducts.removeWhere((product) => product['id'] == productId);
    notifyListeners();
  }

  Future<productModel> getProductDetails(String productId)async{
    print("in get product details provider");
    productDetails =await productVM.productDetails(productId);
    return productDetails;
  }


  Future<void> fetchHandCrafter() async {
    handCrafterProducts = await productVM.handCrafterProducts();
    notifyListeners();
  }
  Future<void> fetchHandCrafterById(String crafterId) async {
    handCrafterProducts = await productVM.handCrafterProductsByID(crafterId);
    notifyListeners();
  }

  Future<List<productModel>> productVariation(List<String> productIds)async{
    return await productVM.productVariation(productIds);
  }




  Future<List<String>> getCartIds()async{
    Cart myCart = Cart();
    myCart.db;
    final id =await token.getUUID() ?? "";

    List<String> ids =
        await myCart.getProductIdsByUser(id);
    return ids;
  }

  Future<bool> checkCustom()async{
    List<String> ids = await getCartIds();
    return await productVM.checkCustom(ids);
  }







}