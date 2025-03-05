import 'package:flutter/material.dart';

import '../Models/CategoryModel.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryService apiServices = CategoryService();
  List<CategoryModel> _categories = [CategoryModel("0", "All")];

  List<CategoryModel> get categories => _categories;

  Future<void> fetchCats() async {
    try {
      _categories = await apiServices.getBasedCategories();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching categories: $e");
      _categories = [CategoryModel("0", "All")]; // Fallback to default category
      notifyListeners();
    }
  }
}