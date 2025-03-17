import 'dart:async';

import 'package:flutter/cupertino.dart';

class detailsProvider extends ChangeNotifier {
  Map<String, dynamic> _selectedVariations = {};
  Map<String, dynamic> get selectedVariations => _selectedVariations;

  List<dynamic> finalProductsProvider = [];
  double finalPrice = 0;

  String? _selectedFinalProductId; // Track the selected final product ID
  String? get selectedFinalProductId => _selectedFinalProductId; // Getter
  List<dynamic> _galleryImages = [];
  int _currentIndex = 0;
  PageController pageController = PageController();

  List<dynamic> get galleryImages => _galleryImages;
  int get currentIndex => _currentIndex;

  detailsProvider() {
    print("detailsProvider initialized");
  }

  void initializeFinalProducts(List<dynamic> finalProducts) {
    selectedVariations.clear(); // Clear selected variations
    finalProductsProvider.clear(); // Clear existing final products
    finalProductsProvider.addAll(finalProducts);
    finalPrice = 0;
    _selectedFinalProductId = null; // Reset selected final product ID
    notifyListeners();
  }

  void selectVariation(String variationType, String variationValue, List<dynamic> finalProducts) {
    _selectedVariations[variationType] = variationValue;
    updateFinalProduct(finalProducts);
    getPrice();
    notifyListeners();
  }

  void deselectVariation(String variationType, List<dynamic> finalProducts) {
    _selectedVariations.remove(variationType);
    updateFinalProduct(finalProducts);
    if (finalProductsProvider == finalProducts) {
      finalPrice = 0;
    } else {
      getPrice();
    }
    notifyListeners();
  }

  void clearVariations() {
    _selectedVariations.clear();
    notifyListeners();
  }

  void addFinalProduct(List<dynamic> finalProducts) {
    finalProductsProvider = finalProducts;
  }

  void updateFinalProduct(List<dynamic> finalProducts) {
    List<dynamic> updatedFinal = [];
    if (selectedVariations.isNotEmpty) {
      for (var finalProduct in finalProducts) {
        final finalProductVariations = finalProduct['finalProductVariation'] as List;
        print(finalProductVariations);

        bool isMatch = true;

        for (var selectedVariation in selectedVariations.entries) {
          final selectedType = selectedVariation.key;
          final selectedValue = selectedVariation.value;

          bool hasVariation = finalProductVariations.any((variation) {
            final productVariation = variation['productVariation'] as Map;
            return productVariation['variationType'] == selectedType &&
                productVariation['variationValue'] == selectedValue;
          });

          if (!hasVariation) {
            isMatch = false;
            break;
          }
        }

        if (isMatch) {
          updatedFinal.add(finalProduct);
        }
      }

      finalProductsProvider = updatedFinal;

      // Update the selected final product ID
      if (updatedFinal.isNotEmpty) {
        _selectedFinalProductId = updatedFinal.first['id']; // Use the first matching product's ID
      } else {
        _selectedFinalProductId = null; // Reset if no matching product
      }
    } else {
      finalProductsProvider = finalProducts;
      _selectedFinalProductId = null; // Reset if no variations are selected
    }
  }

  void getPrice() {
    finalPrice = 0;

    for (var finalProduct in finalProductsProvider) {
      print(finalProduct);
      finalPrice += finalProduct['customPrice'];
    }
  }

}




class galleryImageProvider extends ChangeNotifier {

  List<dynamic> _galleryImages = [];
  int _currentIndex = 0;
  PageController pageController = PageController();

  List<dynamic> get galleryImages => _galleryImages;
  int get currentIndex => _currentIndex;

  detailsProvider() {
    print("galleryImageProvider initialized");
  }

 void setGalleryImages(List<dynamic> galleryImages) {
    _galleryImages = galleryImages;
    notifyListeners();
  }

  void updateCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}



