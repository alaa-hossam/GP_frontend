import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

import '../SqfliteCodes/Token.dart';

class productModel{
  String _imageURL, _name , _category , _id;
  double _price , _rate;
  bool isCustom;
  productModel(
      this._id ,this._imageURL, this._name, this._category, this._price,this.isCustom ,this._rate);

  get rate => _rate;

  double get price => _price;

  get category => _category;

  get name => _name;

  String get imageURL => _imageURL;
}

class productService{
  final String apiUrl = "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();
  List<productModel> products = [];

  Future<String> addProduct(productModel product) async {
    final request = {
      'query': '''
        ''',
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request),
      );

      print("Response: ${response.body}"); // Debugging the response

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['errors'] != null) {
          return data['errors'][0]['message'];
        }
        return "User added successfully";
      } else {
        return jsonDecode(response.body)['errors'][0]['message'];

      }

    } catch (e) {
      print("Exception: $e");
      return e.toString();

    }
  }

  Future<List<productModel>> getAllProducts() async {
    print("Fetching products from API...");

    final request = {
      'query': '''
      query GetBaseCategories {
        getBaseCategories {
          id
          name
        }
      }
      ''',
    };
    print("==========================================================");
    try {
      print("==========================================================");

      final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');
      print("Token retrieved: $myToken");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode(request),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> prods = data['data']['getAllProducts']['data'];
        print(prods);
        products.clear();

        for (var product in prods) {
          products.add(productModel(product['id'],product['imageUrl'], product['name'],product['category']['name'],
            product['finalProducts']['customPrice'],product['finalProducts']['isCustomMade'],product['averageRating']
          ));
        }

        print("Categories fetched successfully: $products");
        return products;
      } else {
        throw Exception('Failed to load categories: ${response.body}');
      }
    } catch (e) {
      print("Error fetching categories: $e");
      return products;
    }
  }

   searchProduct (String word) async{
    Future<List<String>> products;
    final request = {
      'query': '''
      query GetAllProducts {
          getAllProducts(options: { search: "${word}" }) {
            data {
              name
            }
          }   
      }

      ''',
    };

    try {

      final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode(request),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
         products = data['data']['getAllProducts']['data']['name'];
        print(products);
        return products;
      } else {
        throw Exception('Failed to load categories: ${response.body}');
      }
    } catch (e) {
      print("Error fetching categories: $e");
      return e;
    }
}


}