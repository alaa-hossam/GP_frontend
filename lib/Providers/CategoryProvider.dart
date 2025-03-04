import 'package:flutter/cupertino.dart';
import '../ViewModels/CategoryViewModel.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryViewModel CatVM = CategoryViewModel();
  List<String> _categories = [];

  List<String> get categories => _categories;

  CategoryProvider() {
    fetchCategories();
  }

  void fetchCategories() {
    CatVM.fetchCats();
    _categories = CatVM.categories.map((cat) => cat.name).toList();
    notifyListeners();
  }
}