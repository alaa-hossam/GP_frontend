import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/Models/CategoryModel.dart';

class CategoryViewModel  extends ChangeNotifier{
  final CategoryService apiServices = CategoryService();
  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  void fetchCats() {
    try {
      _categories = apiServices.getCategories();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    }
  }
}