import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

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
  final String apiUrl = "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";

  Future<String> addProduct(productModel product) async {
    // Await device token retrieval

    // Ensure gender is in the correct format based on the enum

    // Construct GraphQL mutation query
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


}