import 'package:flutter/cupertino.dart';
import '../Models/ProductModel.dart';
import '../ViewModels/productViewModel.dart';

class cartProvider with ChangeNotifier {
  List<productModel> _cartProducts = [];
  Map<dynamic, int> _finalProductCounts = {};
  productViewModel productVM = productViewModel();

  List<productModel> get cartProducts => _cartProducts;
  Map<dynamic, int> get finalProductCounts => _finalProductCounts;

   getCartProduct() async {
    try {
       _cartProducts = await productVM.cartProducts();
      print("in provider");
     print(cartProducts);
      notifyListeners();


    } catch (e) {
      print("Error fetching cart products: $e");
    }
  }
}