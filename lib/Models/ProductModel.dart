import 'dart:convert';
import 'package:gp_frontend/SqfliteCodes/wishList.dart';
import 'package:http/http.dart' as http;
import '../SqfliteCodes/Token.dart';

class productModel{
  String _imageURL, _name , _category , _id;
  double _price , _rate;
  productModel(
      this._id ,this._imageURL, this._name, this._category, this._price,this._rate);

  get rate => _rate;

  get price => _price;

  get category => _category;

  get name => _name;

  String get imageURL => _imageURL;

  get id => _id;
}

class productService{
  final String apiUrl = "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();
  wishList wish = wishList();
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
      query GetAllProducts {
        getAllProducts {
            data {
                category {
                    name
                }
                averageRating
                id
                imageUrl
                lowestCustomPrice
                name
            }
        }
  }
  ''',
    };

    try {
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
        print(data);

        // Clear the product list only if needed
        products.clear(); // Uncomment this if you want to start fresh each time

        for (var product in prods) {
          products.add(productModel(
            product['id'],
            product['imageUrl'],
            product['name'],
            product['category']['name'],
            // Convert to double to avoid type errors
            product['lowestCustomPrice'].toDouble(),
            product['averageRating'].toDouble(),
          ));
        }

        print("Products fetched successfully: $products");
        return products;
      } else {
        throw Exception('Failed to load products: ${response.body}');
      }
    } catch (e) {
      print("Error fetching products: $e");
      return []; // Return an empty list in case of error
    }
  }

  Future<List<dynamic>> searchProduct (String word) async{
    List<dynamic> products;
    print("before");
    final request = {
      'query': '''
      query GetAllProducts {
          getAllProducts(options: { search: "${word}" }) {
            data {
              name
              imageUrl
              id
            }
          }   
      }

      ''',
    };
    print("after");

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
      print("response status:");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("products inside the api");

        final data = jsonDecode(response.body);
         products = data['data']['getAllProducts']['data'];
        print(data);
        return products;
      } else {
        throw Exception('Failed to load categories: ${response.body}');
      }
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
}


  Future<List<dynamic>> getWishProducts() async {
    List<String> ids = await wish.getProduct("SELECT * FROM WISHLIST").then((result) {
      return result.map<String>((row) => row['ID'].toString()).toList();
    });

    print("ids are:");
    print(ids);

    const String query = '''
    query GetProductsByIds(\$productIds: [String!]!) {
      getProductsByIds(productIds: \$productIds) {
        imageUrl
        lowestCustomPrice
        name
        averageRating
        category {
          name
        }
        id
      }
    }
  ''';

    final request = {
      'query': query,
      'variables': {
        'productIds': ids,
      },
    };

    try {
      final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');

      // Step 5: Send the request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode(request),
      );

      // Debug: Print the response body
      print(response.body);

      // Step 6: Handle the response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> prods = data['data']['getProductsByIds'];
        print(prods);

        // Step 7: Map the response to productModel objects
        // for (var product in prods) {
        //   products.add(productModel(
        //     product['id'],
        //     product['imageUrl'],
        //     product['name'],
        //     product['category']['name'],
        //     product['lowestCustomPrice'],
        //     product['averageRating'],
        //   ));
        // }

        print("Products fetched successfully: $prods");
        return prods;
      } else {
        throw Exception('Failed to load products: ${response.body}');
      }
    } catch (e) {
      print("Error fetching products: $e");
      return products;
    }
  }

}