import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class detailsProvider extends ChangeNotifier{
  Map<String, dynamic> _selectedVariations = {};
  Map<String, dynamic> get selectedVariations => _selectedVariations;


  detailsProvider() {
    print("detailsProvider initialized");
  }


  void selectVariation(String variationType, String variationValue) {
    _selectedVariations[variationType] = variationValue;
    notifyListeners(); // Notify listeners to rebuild widgets
  }

  void clearVariations() {
    _selectedVariations.clear();
    notifyListeners();
  }
}