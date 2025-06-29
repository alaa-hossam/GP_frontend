import '../Models/SearchModel.dart';

class SearchViewModel{
  final SearchService apiServices = SearchService();

  List<SearchModel> _products = [];
  List<SearchModel> get products => _products;

  Future <List<SearchModel>> getSearchProducts(List<String> ids)async{
    return await apiServices.getSearchProducts(ids);
  }

  Future<List<SearchModel>> searchProduct(String word){
    return apiServices.searchProduct(word);
  }

}