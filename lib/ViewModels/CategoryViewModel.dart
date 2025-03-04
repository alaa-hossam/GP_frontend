import 'package:flutter/material.dart';

import '../Models/CategoryModel.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryService apiServices = CategoryService();
  List<CategoryModel> _categories = [CategoryModel("0", "All")];

  List<CategoryModel> get categories => _categories;

  Future<void> fetchCats() async {
    try {
      print("Fetching categories from API...");
      _categories = await apiServices.getBasedCategories();
      print("Categories fetched successfully: $_categories");
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching categories: $e");
      _categories = [CategoryModel("0", "All")]; // Fallback to default category
      notifyListeners();
    }
  }
}