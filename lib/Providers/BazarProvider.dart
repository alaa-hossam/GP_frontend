import 'package:flutter/cupertino.dart';
import '../Models/ProductModel.dart';
import '../ViewModels/productViewModel.dart';

class BazarProvider extends ChangeNotifier {
  List<productModel> myProducts = [];
  Map<String, bool> productSelections = {}; // Tracks selected variations
  final Map<String, String> _quantityValues = {}; // Stores quantity per variationId
  final Map<String, String> _offers = {}; // Stores offer per productId

  productViewModel productVM = productViewModel();

  BazarProvider() {
    productSelections.clear();
    myProducts.clear();
    _quantityValues.clear();
    _offers.clear();
  }

  Future<void> productVariation(List<String> productIds) async {
    try {
      List<productModel> products = await productVM.productVariation(productIds);
      myProducts = products;
      print("....");

      for (var product in products) {
        if (product.variationsWithIds != null) {
          for (var entry in product.variationsWithIds!.entries) {
            productSelections[entry.key] = false;
          }
        }
      }

      print(productSelections.entries);
    } catch (e) {
      print('Error in productVariation: $e');
      rethrow;
    }
  }
  void displayQuantity(String variationId) {
    if (productSelections.containsKey(variationId)) {
      final isSelected = productSelections[variationId]!;

      // Toggle selection
      productSelections[variationId] = !isSelected;

      if (!isSelected) {
        _quantityValues.remove(variationId);
      }

      notifyListeners();
    }
  }

  void setQuantity(String variationId, String value) {
    // Sanitize and store quantity
    if (value.trim().isEmpty || int.tryParse(value) == null || int.parse(value) <= 0) {
      _quantityValues.remove(variationId); // optional: clear if invalid
    } else {
      _quantityValues[variationId] = value;
    }

    // No notifyListeners here to avoid unnecessary rebuilds
  }


  String getQuantity(String variationId) {
    return _quantityValues[variationId] ?? '';
  }

  void setOffer(String productId, String offerValue) {
    _offers[productId] = offerValue;
  }

  String getOffer(String productId) {
    return _offers[productId] ?? '';
  }

  /// Use this when navigating to the BazarReview screen
  List<Map<String, dynamic>> getSelectedProductDetails() {
    List<Map<String, dynamic>> selectedDetails = [];

    for (var product in myProducts) {
      String productId = product.id ?? '';
      String offer = _offers[productId] ?? '';

      if (product.variationsWithIds != null) {
        for (var entry in product.variationsWithIds!.entries) {
          String variationId = entry.key;
          if (productSelections[variationId] == true) {
            String quantity = _quantityValues[variationId] ?? '';
            selectedDetails.add({
              'product': product,
              'variationId': variationId,
              'variationAttributes': entry.value,
              'quantity': quantity,
              'offer': offer,
            });
          }
        }
      }
    }

    return selectedDetails;
  }

  int getTotalQuantityForProduct(String productId) {
    int total = 0;

    final product = myProducts.firstWhere((p) => p.id == productId, orElse: () => productModel("","","",0,0));
    if (product.variationsWithIds != null) {
      for (var entry in product.variationsWithIds!.entries) {
        String variationId = entry.key;
        if (productSelections[variationId] == true) {
          final quantityStr = _quantityValues[variationId];
          if (quantityStr != null && int.tryParse(quantityStr) != null) {
            total += int.parse(quantityStr);
          }
        }
      }
    }

    return total;
  }

}
