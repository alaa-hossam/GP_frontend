import 'package:flutter/cupertino.dart';
import '../Models/ProductModel.dart';
import '../ViewModels/productViewModel.dart';

class cartProvider with ChangeNotifier {
  List<productModel> _cartProducts = [];
  Map<dynamic, int> _finalProductCounts = {};
  productViewModel productVM = productViewModel();

  List<productModel> get cartProducts => _cartProducts;
  Map<dynamic, int> get finalProductCounts => _finalProductCounts;
  bool _isLoading = false;
  bool get isLoading => _isLoading;


  getCartProduct() async {
    _isLoading = true;
    notifyListeners();
    try {
       _cartProducts = await productVM.cartProducts();
       _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error fetching cart products: $e");
    }
  }

  deleteCartProduct(String finalId) async{
     await productVM.deleteCartProduct(finalId);
     getCartProduct();
   }

}