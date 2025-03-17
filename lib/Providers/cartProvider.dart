import 'package:flutter/cupertino.dart';
import '../ViewModels/productViewModel.dart';

class cartProvider with ChangeNotifier {
  List<dynamic> _cartProducts = [];
  Map<dynamic, int> _finalProductCounts = {}; // To store counts of final products
  productViewModel productVM = productViewModel();

  List<dynamic> get cartProducts => _cartProducts;
  Map<dynamic, int> get finalProductCounts => _finalProductCounts;

  Future<Map<String, dynamic>> getCartProduct() async {
    print("in Provider");
    try {
      // Fetch cart products from the ViewModel
      var result = await productVM.cartProducts();

      // Update the internal state
      _cartProducts = result['cartProducts'];
      _finalProductCounts = result['finalProductCounts'];

      // Notify listeners to update the UI
      notifyListeners();

      // Return the result
      return {
        'cartProducts': _cartProducts,
        'finalProductCounts': _finalProductCounts,
      };
    } catch (e) {
      print("Error fetching cart products: $e");
      // Return an empty structure in case of error
      return {
        'cartProducts': [],
        'finalProductCounts': {},
      };
    }
  }
}