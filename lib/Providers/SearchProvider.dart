import 'package:flutter/foundation.dart';
import 'package:gp_frontend/Models/SearchModel.dart';

import '../ViewModels/SearchViewModel.dart';

class SearchProvider extends ChangeNotifier{
  List<SearchModel> _searchProducts = [];
  List<SearchModel> get searchProducts => _searchProducts;
  SearchViewModel searchVM = SearchViewModel();
  bool loading = false;

  getSearchProducts(String word) {
    searchVM.searchProduct(word);
    _searchProducts = searchVM.products.map((product) => product).toList();
  }

  getSearchProductsImage(List<String> ids)async {
    loading = true;
    notifyListeners();
    _searchProducts = await searchVM.getSearchProducts(ids);
    loading = false;
    notifyListeners();

  }


}