import 'package:flutter/cupertino.dart';
import '../Models/CategoryModel.dart';
import '../ViewModels/CategoryViewModel.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryViewModel categoryVM = CategoryViewModel();
  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;
  List<CategoryModel> _categoryCildren = [];
  List<CategoryModel> get categoryCildren => _categoryCildren;

  CategoryProvider() {
    print("CategoryProvider initialized");
  }

  Future<void> fetchCategories() async {
    print("Fetching categories...");
    await categoryVM.fetchCats();
    _categories = categoryVM.categories.map((cat) => cat).toList();
    print("Categories fetched: $_categories");
    notifyListeners();
  }
  Future<void> fetchCategoryChildren(String parentId) async {
    print("Fetching categories children...");
    await categoryVM.fetchCategoryCildren(parentId);
    _categoryCildren = categoryVM.categoryCildren.map((cat) => cat).toList();
    print("Categories Children fetched: $_categoryCildren");
    notifyListeners();
  }
}