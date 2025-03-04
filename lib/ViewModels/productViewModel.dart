import 'package:flutter/cupertino.dart';

import '../Models/ProductModel.dart';

class productViewModel  extends ChangeNotifier{
  final productService apiServices = productService();
  List<productModel> _products = [];

  List<productModel> get products => _products;

  void fetchProducts() {

  }
}