import 'dart:convert';
import 'package:gp_frontend/SqfliteCodes/cart.dart';
import 'package:http/http.dart' as http;

class CategoryModel {
  final String id;
  final String name;

  CategoryModel(this.id, this.name);
}

class CategoryService {
  final String apiUrl = "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();
  List<CategoryModel> myCategories = [CategoryModel("0", "All")];

  // Add a method to get the token (you can replace this with your actual token retrieval logic)
  // Future<String> getToken() async{
  //   String query = '''
  //     SELECT TOKEN FROM TOKENS
  // ''';
  //   String myToken = await token.getToken(query);
  //   print("My toooooooooooooken" + myToken);
  //   return myToken;
  // }

  Future<List<CategoryModel>> getBasedCategories() async {
    print("Herrrrrrrrrre");

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

    try {
      // Get the token
      final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');

      // Make the HTTP request with the Bearer token
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken', // Add the Bearer token here
        },
        body: jsonEncode(request),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> categories = data['data']['getBaseCategories'];

        // Clear existing categories before adding new ones
        myCategories.clear();

        // Add the default category
        myCategories.add(CategoryModel("0", "All"));

        // Map the fetched categories to CategoryModel
        for (var category in categories) {
          myCategories.add(CategoryModel(category['id'], category['name']));
        }

        return myCategories;
      } else {
        throw Exception('Failed to load categories: ${response.body}');
      }
    } catch (e) {
      print("Error: $e");
      return myCategories;
    }
  }
}