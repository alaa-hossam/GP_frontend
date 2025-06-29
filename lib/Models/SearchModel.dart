import 'dart:convert';

import 'package:http/http.dart' as http;

import '../SqfliteCodes/Token.dart';

class SearchModel{
  String? name, imageUrl, id, categoryName;
  double? lowestCustomPrice, averageRating;

  SearchModel(
      {this.name,
      this.imageUrl,
      this.id,
      this.categoryName,
      this.lowestCustomPrice,
      this.averageRating});
}

class SearchService{
  final String apiUrl =
      "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();

  Future<List<SearchModel>> searchProduct(String word) async {

    List<SearchModel> products = [];
    print("before");
    final request = {
      'query': '''
      query GetAllProducts {
          getAllProducts(options: { search: "${word}" }) {
            data {
              name
              imageUrl
              id
              lowestCustomPrice
              averageRating
              category {
                name
            }
            
            }
          }   
      }

      ''',
    };
    print("after");

    try {
      final myToken = await token.getToken();
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode(request),
      );
      print("response status:");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("products inside the api");

        final data = jsonDecode(response.body);
        print(data);
        List<dynamic> productsData = data['data']['getAllProducts']['data'];
        for (var product in productsData) {
          products.add(SearchModel(
              id: product['id'],
              imageUrl: product['imageUrl'],
              name: product['name'],
              lowestCustomPrice: product['lowestCustomPrice'].toDouble(),
              averageRating: product['averageRating'].toDouble(),
              categoryName: product['category']['name']));
        }
        return products;
      } else {
        throw Exception('Failed to load categories: ${response.body}');
      }
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }


  Future<List<SearchModel>> getSearchProducts(List<String> productIds) async {
    List<SearchModel> products = [];

    const String query = '''
    query GetProductsByIds(\$productIds: [String!]!) {
      getProductsByIds(productIds: \$productIds) {
         
        category {
            name
        }
        id
        imageUrl
        name
        lowestCustomPrice
        averageRating

      }
    }
  ''';

    final request = {
      'query': query,
      'variables': {
        'productIds': productIds,
      },
    };

    try {
      final myToken = await token.getToken();

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
        List<dynamic> prods = data['data']['getProductsByIds'];
        for (var pro in prods) {
          products.add(
            SearchModel(id: pro['id'],imageUrl:  pro['imageUrl'],name:  pro['name'],
                lowestCustomPrice: pro['lowestCustomPrice'].toDouble(),
                categoryName: pro['category']['name']),
          );
        }

        print("Products fetched successfully: $products");
        return products;
      } else {
        throw Exception('Failed to load products: ${response.body}');
      }
    } catch (e) {
      print("Error fetching products: $e");
      return products;
    }
  }


}