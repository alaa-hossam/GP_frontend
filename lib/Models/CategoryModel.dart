import 'dart:convert';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:http/http.dart' as http;

import 'ProductModel.dart';

class CategoryModel {
  final String id;
  final String name;

  CategoryModel(this.id, this.name);
}

class CategoryService {
  final String apiUrl = "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();

  Future<List<CategoryModel>> getBasedCategories() async {
    List<CategoryModel> myCategories = [];
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
        List<dynamic> categories = data['data']['getBaseCategories'];
        print(categories);
        myCategories.clear();
        myCategories.add(CategoryModel("0", "All"));

        for (var category in categories) {
          myCategories.add(CategoryModel(category['id'], category['name']));
        }

        print("Categories fetched successfully: $myCategories");
        return myCategories;
      } else {
        throw Exception('Failed to load categories: ${response.body}');
      }
    } catch (e) {
      print("Error fetching categories: $e");
      return myCategories;
    }
  }



  Future<List<CategoryModel>> getCategoryChild(String parentId) async {
    List<CategoryModel> myCategories = [];
    final request = {
      'query': '''
        query GetCategory {
            getCategory(
            categoryId: "$parentId") {
                children {
                    id
                    name
                }
                name
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
        List<dynamic> categories = data['data']['getCategory']['children'];
        print(categories);
        myCategories.clear();
        myCategories.add(CategoryModel("0", data['data']['getCategory']['name']));

        for (var category in categories) {
          myCategories.add(CategoryModel(category['id'], category['name']));
        }

        print("Categories children fetched successfully: $myCategories");
        return myCategories;
      } else {
        throw Exception('Failed to load categories children: ${response.body}');
      }
    } catch (e) {
      print("Error fetching categories children: $e");
      return myCategories;
    }
  }

}