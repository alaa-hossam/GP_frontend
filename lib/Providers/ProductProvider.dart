import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/SqfliteCodes/wishList.dart';
import '../Models/ProductModel.dart';
import '../SqfliteCodes/Token.dart';
import '../ViewModels/customerViewModel.dart';
import '../ViewModels/productViewModel.dart';

class productProvider extends ChangeNotifier {
  productViewModel productVM = productViewModel();
  List<productModel> _products = [] , handCrafterProducts = [];
  List<productModel> get products => _products;
  List<productModel>  bazarProducts = [];
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

  getSearchProducts(String word) {
    productVM.searchProduct(word);
    _products = productVM.products.map((product) => product).toList();
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
    final email = await token.getEmail('SELECT EMAIL FROM TOKENS');

    if (_wishlistItems.contains(productId)) {
      await _wishListObj.deleteProduct('''
        DELETE FROM WISHLIST 
        WHERE ID = "$productId" AND EMAIL = "$email"
      ''');
      _wishlistItems.remove(productId);
    } else {
      await _wishListObj.addProduct('''
        INSERT INTO WISHLIST(ID,EMAIL) 
        VALUES ("$productId","$email")
      ''');
      _wishlistItems.add(productId);
    }
    notifyListeners();
  }
  // Make this method async and await the result
  Future<void> getWishProducts() async {

    wishListProducts = await productVM.wishProducts();
    notifyListeners(); // Notify listeners after updating the data
  }
  Future<void> deleteProduct(String id) async {
    // Delete the product from the database
    // customerViewModel customer = customerViewModel();
    String email = await token.getEmail('SELECT EMAIL FROM TOKENS');


    await wishList().deleteProduct('''
      DELETE FROM WISHLIST 
        WHERE ID = "$id" AND EMAIL = "$email"
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


  Future<void> fetchHandCrafter() async {

    handCrafterProducts = await productVM.handCrafterProducts();
    notifyListeners();
  }

  Future<List<productModel>> productVariation(List<String> productIds)async{
    return await productVM.productVariation(productIds);
  }

  getBazarProducts()async{
    print("in bazar");
     bazarProducts = await productVM.getBazarProducts();
     notifyListeners();
  }





}