import 'package:flutter/material.dart';

import '../Models/CategoryModel.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryService apiServices = CategoryService();
  List<CategoryModel> _categories = [CategoryModel("0", "All")];
  List<CategoryModel> get categories => _categories;
  List<CategoryModel> _specialization = [];
  List<CategoryModel> get specialization => _specialization;
  List<CategoryModel> _categoryCildren = [];
  List<CategoryModel> get categoryCildren => _categoryCildren;

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
  Future<void> fetchSpecialization() async {
    try {
      _specialization = await apiServices.getAllSpcialization();
      print("in VM");
      print(specialization.length);
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching Specialization: $e");
      _specialization = [];
      notifyListeners();
    }
  }
  Future<void> fetchCategoryCildren(String parentId) async {
    try {
      _categoryCildren = await apiServices.getCategoryChild(parentId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching categories Cildren: $e");
      _categories = [CategoryModel("0", "All")];
      notifyListeners();
    }
  }
}