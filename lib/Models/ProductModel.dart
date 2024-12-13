class productModel{
  String _imageURL, _name , _category;
  double _price , _rate;

  productModel(
      this._imageURL, this._name, this._category, this._price, this._rate);

  get rate => _rate;

  double get price => _price;

  get category => _category;

  get name => _name;

  String get imageURL => _imageURL;
}

class productService{
  List<productModel> getProducts (){
    return [
      productModel('assets/images/p1.jpg', "Rose embroidery", "Textiles", 150.0, 4.6),
      productModel('assets/images/p2.jpg', "owl on glass", "Glass", 160.0, 4.8),
      productModel('assets/images/p3.jpg', "Makramia", "Texttiles", 210.0, 4.5),
    ];

}
}