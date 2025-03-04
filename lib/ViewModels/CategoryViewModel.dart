import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/Models/CategoryModel.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryService apiServices = CategoryService();
  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  Future<void> fetchCats() async {
    try {
      _categories = await apiServices.getBasedCategories();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    }
  }
}