import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class detailsProvider extends ChangeNotifier{
  Map<String, dynamic> _selectedVariations = {};
  Map<String, dynamic> get selectedVariations => _selectedVariations;
  List<dynamic> finalProductsProvider = [];
  double finalPrice = 0;



  detailsProvider() {
    print("detailsProvider initialized");
  }

  void initializeFinalProducts(List<dynamic> finalProducts) {
    selectedVariations.clear(); // Clear selected variations
    finalProductsProvider.clear(); // Clear existing final products
    finalProductsProvider.addAll(finalProducts);
    finalPrice=0;
    notifyListeners();
  }


  void selectVariation(String variationType, String variationValue) {
    _selectedVariations[variationType] = variationValue;
    notifyListeners(); // Notify listeners to rebuild widgets
  }

  void deselectVariation(String variationType) {
    _selectedVariations.remove(variationType);
    notifyListeners(); // Notify listeners to rebuild relevant widgets
  }

  void clearVariations() {
    _selectedVariations.clear();
    notifyListeners();
  }

  void addFinalProduct(List<dynamic> finalProucts){
    finalProductsProvider = finalProucts;
  }

  void updateFinalProduct( List<dynamic> finalProducts) {
    List<dynamic> updatedFinal = [];
    if (selectedVariations.isNotEmpty) {
      // finalProductsProvider.clear();

      for (var finalProduct in finalProducts) {
        final finalProductVariations = finalProduct['finalProductVariation'] as List;

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
          // print(finalProduct);
          updatedFinal.add(finalProduct);
        }
      }
      finalProductsProvider = updatedFinal;
    }


  }

   getPrice(){
    finalPrice =0;
    for(var finalProduct in finalProductsProvider){
      finalPrice += finalProduct['customPrice'];
    }
notifyListeners();
  }
}