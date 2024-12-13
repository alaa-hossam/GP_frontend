class CategoryModel {
  String _id;
  String _name;

  CategoryModel(this._id, this._name);

  String get name => _name;

  String get id => _id;
}


class CategoryService{
  List<CategoryModel> myCategories = [CategoryModel("0", "All")];
  List<CategoryModel> getCategories() {
    return myCategories + [
      CategoryModel("1" , "Text Tiles"),
      CategoryModel("2" , "Wood"),
      CategoryModel("3" , "Glass"),
      CategoryModel("4" , "Pottery"),
      CategoryModel("5" , "Jewelery"),
    ];
  }
}