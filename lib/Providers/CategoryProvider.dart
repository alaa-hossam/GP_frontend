import 'package:flutter/cupertino.dart';
import '../ViewModels/CategoryViewModel.dart';

// class CategoryProvider extends ChangeNotifier {
//   CategoryViewModel CatVM = CategoryViewModel();
//   List<String> _categories = [];
//
//   List<String> get categories => _categories;
//
//   CategoryProvider() {
//     print("in provider");
//
//     fetchCategories();
//   }
//
//   void fetchCategories() async{
//     print("in provider");
//     await CatVM.fetchCats();
//     _categories = CatVM.categories.map((cat) => cat.name).toList();
//     notifyListeners();
//   }
// }

class CategoryProvider extends ChangeNotifier {
  CategoryViewModel categoryVM = CategoryViewModel();
  List<String> _categories = [];

  List<String> get categories => _categories;

  CategoryProvider() {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    await categoryVM.fetchCats();
    notifyListeners(); // Notify listeners after fetching data
  }
}