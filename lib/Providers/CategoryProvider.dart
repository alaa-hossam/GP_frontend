import 'package:flutter/material.dart';
import '../Models/CategoryModel.dart';
import '../ViewModels/CategoryViewModel.dart';

class CategoryProvider with ChangeNotifier {
  CategoryViewModel categoryVM = CategoryViewModel();

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  List<CategoryModel> _categoryCildren = [];
  List<CategoryModel> get categoryCildren => _categoryCildren;

  List<CategoryModel> _specialization = [];
  List<CategoryModel> get specialization => _specialization;

  // Single specialization selection
  String? _selectedSpecialization;
  String? _selectedSpecializationId;

  String? get selectedSpecialization => _selectedSpecialization;
  String? get selectedSpecializationId => _selectedSpecializationId;

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

  Future<void> fetchSpecializations() async {
    print("Fetching specializations...");
    await categoryVM.fetchSpecialization();
    _specialization = categoryVM.specialization.map((spec) => spec).toList();
    print("Specializations fetched: $_specialization");
    notifyListeners();
  }

  Future<void> fetchCategoryChildren(String parentId) async {
    print("Fetching category children for ID: $parentId");
    await categoryVM.fetchCategoryCildren(parentId);
    _categoryCildren = categoryVM.categoryCildren.map((cat) => cat).toList();
    print("Category children fetched: $_categoryCildren");
    notifyListeners();
  }

  // Select a single specialization
  void selectSpecialization(String name, String id) {
    _selectedSpecialization = name;
    _selectedSpecializationId = id;
    notifyListeners();
  }

  // Clear the selected specialization
  void clearSelected() {
    _selectedSpecialization = null;
    _selectedSpecializationId = null;
    notifyListeners();
  }
}
