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


//   Future<List<CategoryModel>,List<productModel>> getCategory(String id) async {
//     List<CategoryModel> myCategories = [];
//     List<productModel> products = [];
//
//     final request = {
//       'query': '''
//       query GetCategory {
//     getCategory(categoryId: "$id") {
//         children {
//             name
//             id
//         }
//         products {
//             averageRating
//             id
//             imageUrl
//             lowestCustomPrice
//             name
//         }
//         name
//     }
// }
//
//       ''',
//     };
//     try {
//
//       final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');
//
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $myToken',
//         },
//         body: jsonEncode(request),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         List<dynamic> categories = data['data']['getCategory']['children'];
//         final name = data['data']['getCategory']['name'];
//         print(categories);
//         List<dynamic> prods = data['data']['getCategory']['products'];
//         print(prods);
//         for (var product in prods) {
//           products.add(productModel(
//             product['id'],
//             product['imageUrl'],
//             product['name'],
//             product['category']['name'],
//             // Convert to double to avoid type errors
//             product['lowestCustomPrice'].toDouble(),
//             product['averageRating'].toDouble(),
//           ));
//         }
//         myCategories.clear();
//         myCategories.add(CategoryModel("0", name));
//         for (var category in categories) {
//           myCategories.add(CategoryModel(category['id'], category['name']));
//         }
//
//         print("Categories fetched successfully: $myCategories");
//         return myCategories;
//       } else {
//         throw Exception('Failed to load categories: ${response.body}');
//       }
//     } catch (e) {
//       print("Error fetching categories: $e");
//       return myCategories;
//     }
//   }


}