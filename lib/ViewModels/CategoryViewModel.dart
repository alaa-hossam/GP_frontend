import 'package:flutter/material.dart';

import '../Models/CategoryModel.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryService apiServices = CategoryService();
  List<CategoryModel> _categories = [CategoryModel("0", "All")]; // Initialize with default category

  List<CategoryModel> get categories => _categories;

  Future<void> fetchCats() async {
    try {
      _categories = await apiServices.getBasedCategories();
      notifyListeners(); // Notify listeners after updating categories
    } catch (e) {
      debugPrint("Error fetching categories: $e");
      // Keep the default categories if fetching fails
      _categories = [CategoryModel("0", "All")];
      notifyListeners();
    }
  }
}