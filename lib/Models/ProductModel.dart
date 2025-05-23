import 'dart:convert';
import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:gp_frontend/SqfliteCodes/wishList.dart';
import 'package:gp_frontend/ViewModels/customerViewModel.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import '../SqfliteCodes/Token.dart';
import '../SqfliteCodes/cart.dart';

class productModel {
  String _imageURL, _name, _id;
  String? description, handcrafterName, category , handcrafterImage, finalId;
  double _price, _rate;
  double? stock , duration;
  int? ratingCount, Quantity;
  List<dynamic>? finalProducts, variations;
  Map<String, List<dynamic>>? variationsWithIds;
  List<dynamic>? reviews;
  List<String>? galleryImg;
  productModel(this._id, this._imageURL, this._name, this._price, this._rate,
      {this.description,
      this.stock,
      this.handcrafterName,
      this.ratingCount,
      this.category,
      this.finalProducts,
      this.variations,
      this.handcrafterImage,
      this.reviews,
      this.galleryImg,
      this.Quantity,
      this.finalId,
      this.duration,
      this.variationsWithIds});



  double get rate => _rate;
  double get price => _price;
  String get name => _name;
  String get imageURL => _imageURL;
  String get id => _id;
}
class productService {
  final String apiUrl =
      "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();
  wishList wish = wishList();
  Cart myCart = Cart();
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

  Future<List<productModel>> getAllProducts(String categoryId) async {
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
            description
             finalProducts {
                stockQuantity
            }
            }
        }
  }
  ''',
    };
    final requestCategory = {
      'query': '''
          query GetAllProducts {
    getAllProducts(categoryId: "$categoryId") {
        data {
            averageRating
            id
            imageUrl
            lowestCustomPrice
            name
            category {
                name
            }
            description
            finalProducts {
                stockQuantity
            }
        }
    }
}

      ''',
    };

    try {
      final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');
      print("Token retrieved: $myToken");
      final response;
      if (categoryId == '0') {
        response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $myToken',
          },
          body: jsonEncode(request),
        );
      } else {
        response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $myToken',
          },
          body: jsonEncode(requestCategory),
        );
      }

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
            category: product['category']['name'],
            // Convert to double to avoid type errors
            product['lowestCustomPrice'].toDouble(),
            product['averageRating'].toDouble(),
            description: product['description'],
            stock: product['stockQuantity'],
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

  Future<List<productModel>> getGifRecommendationProducts(Map<String, String> answers) async {
    print("Fetching products from API...");
    List<productModel> giftProducts = [];

    // Convert the answers map into the required qaPairs format
    List<String> qaPairs = [];
    answers.forEach((key, value) {
      qaPairs.add('{ question: "$key", answer: "$value" }');
    });

    // Construct the GraphQL query string
    final query = '''
    query GiftRecommendations {
      giftRecommendations(
        input: { qaPairs: [${qaPairs.join(', ')}] }
      ) {
        id
        imageUrl
        category {
          name
        }
        name
        averageRating
        lowestCustomPrice
      }
    }
  ''';

    final request = {
      'query': query,
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
        List<dynamic> prods = data['data']['giftRecommendations'];
        print(data);

        for (var product in prods) {
          giftProducts.add(productModel(
            product['id'],
            product['imageUrl'],
            product['name'],
            category: product['category']['name'],
            product['lowestCustomPrice'].toDouble(),
            product['averageRating'].toDouble(),
          ));
        }

        print("Products fetched successfully: $giftProducts");
        return giftProducts;
      } else {
        throw Exception('Failed to load products: ${response.body}');
      }
    } catch (e) {
      print("Error fetching products: $e");
      return []; // Return an empty list in case of error
    }
  }


  Future<List<productModel>> HistoryProducts() async {
    print("Fetching history products from API...");
    List<productModel> historyProducts = [];

    final userId = await token.getUUID('SELECT UUID FROM TOKENS');

    final query = '''
        query GetUserHistory {
            getUserHistory(userId: "${userId}") {
                product {
                    averageRating
                    category {
                        name
                    }
                    imageUrl
                    id
                    lowestCustomPrice
                    name
                }
            }
        }
  ''';

    final request = {
      'query': query,
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
        List<dynamic> prods = data['data']['getUserHistory'];
        print(data);

        for (var historyItem in data['data']['getUserHistory']) {
          if (historyItem['product'] != null) {
            var product = historyItem['product'];
            historyProducts.add(productModel(
              product['id'],
              product['imageUrl'],
              product['name'],
              category: product['category']['name'],
              // Convert to double to avoid type errors
              product['lowestCustomPrice'].toDouble(),
              product['averageRating'].toDouble(),
            ));
          }
        }

        print("history Products fetched successfully: $historyProducts");
        return historyProducts;
      } else {
        throw Exception('Failed to load history products: ${response.body}');
      }
    } catch (e) {
      print("Error fetching history products: $e");
      return [];
    }
  }

  Future<String> addProductReview(String comment, String productId, double rate) async {
    print("Fetching products from API...");
    final userId = await token.getUUID('SELECT UUID FROM TOKENS');

    final query = '''
    mutation CreateProductReview {
      createProductReview(
        createProductReviewDto: { 
          comment: "$comment", 
          productId: "$productId", 
          rating: $rate, 
          userId: "$userId" 
        }
      ) {
        createdAt
      }
    }
  ''';

    final request = {
      'query': query,
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
        print(data);

        if (data['data'] != null && data['data']['createProductReview'] != null) {
          print("Review sent successfully");
          return "review sent successfully";
        } else if (data['errors'] != null) {
          return data['errors'][0]['message'];
        } else {
          return "Unknown error occurred";
        }
      } else {
        return "Failed to send review: ${response.body}";
      }
    } catch (e) {
      print("Error sending review: $e");
      return "Error sending review: $e";
    }
  }

  Future<List<dynamic>> searchProduct(String word) async {
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

    String email = await token.getEmail('SELECT EMAIL FROM TOKENS');
    wishList myWish = wishList();

    List<String> ids = await myWish.getProductIdsByEmail(email);

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

  Future<List<productModel>> getCartProducts() async {
    // Step 1: Fetch product IDs and final IDs from SQLite
    myCart.db;
    List<String> ids =
    await myCart.getProduct("SELECT * FROM products").then((result) {
      return result.map<String>((row) => row['id'].toString()).toList();
    });
    List<String> finalIds =
    await myCart.getProduct("SELECT * FROM products").then((result) {
      return result.map<String>((row) => row['finalId'].toString()).toList();
    });
    Map<String , int> numOfIds = {};

    for(var id in finalIds){
      if (numOfIds.containsKey(id)) {
        numOfIds[id] = numOfIds[id]! + 1;
      } else {
        numOfIds[id] = 1;
      }
    }


    print("Product IDs: $finalIds");

    const String query = '''
  query GetFinalProductsByIds(\$finalProductIds: [String!]!) {
    getFinalProductsByIds(finalProductIds: \$finalProductIds) {
      customPrice
      imageUrl
      product {
        name
        category {
          name
        }
        id
        averageRating
      }
      id
       finalProductVariation {
            productVariation {
                variationType
                variationValue
            }
        }

    }
  }
''';
    final request = {
      'query': query,
      'variables': {
        'finalProductIds': finalIds,
      },
    };

    try {
      // Step 3: Get the authentication token
      final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');
      print("Token in getCartProducts: $myToken");

      // Step 4: Send the request to the API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode(request),
      );
      // Step 5: Handle the response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> prods = data['data']['getFinalProductsByIds'];


        List<productModel> finalProducts = [];


        for (var product in prods) {
          try {
            finalProducts.add(productModel(
              product['product']['id'],
              product['imageUrl'],
              product['product']['name'],
              product['customPrice'].toDouble(),
              product['product']['averageRating'].toDouble(),
              category: product['product']['category']['name'],
              variations: product['finalProductVariation'],
                finalId: product['id'],
              Quantity: numOfIds[product['id']]
            ));

          } catch (e) {
            print("Error adding product: $e"); // Log the error
            print("Problematic product: $product"); // Log the problematic product
          }
        }
        return finalProducts;

      } else {
        throw Exception('Failed to load products: ${response.body}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<productModel> getProductDetails(String productId) async {
    final viewerId = await token.getUUID('SELECT UUID FROM TOKENS');

    String query = '''
    query GetProduct {
      getProduct(
        productId:  "$productId"
        viewerId:  "$viewerId"
      ) {
        description
        imageUrl
        name
        ratingCount
        averageRating
        id
        variations {
          variationType
          variationValue
          sizeUnit
        }
        finalProducts {
          imageUrl
          isCustomMade
          duration
          customPrice
          stockQuantity
          id
          finalProductVariation {
            productVariation {
              variationType
              variationValue
            }
          }
          galleryImages {
            imageUrl
          }
        }
        handicrafter {
          id
          username
        }
        reviews {
          comment
          createdAt
          rating
          userId
        }
        category {
          name
        }
      }
    }
  ''';

    final request = {
      'query': query,
      'variables': {
        'productId': productId,
        'viewerId': viewerId,
      },
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
        final Map<String, dynamic> data = jsonDecode(response.body);

        final Map<String, dynamic>? getProduct = data['data']?['getProduct'];
        if (getProduct != null) {
          // Access fields in getProduct
          final String name = getProduct['name'] ?? 'No Name';
          final String description = getProduct['description'] ?? 'No Description';
          final String imageUrl = getProduct['imageUrl'] ?? 'https://via.placeholder.com/150';
          final double averageRating = getProduct['averageRating'].toDouble() ; // Handle null
          final double lowestCustomPrice = getProduct['lowestCustomPrice']?.toDouble() ?? 0.0; // Handle null
          final int ratingCount = getProduct['ratingCount'] ?? 0;
          final String id = getProduct['id'] ?? 'No ID';
          final String handcrafterName = getProduct['handicrafter']['username'] ?? 'No Name';
          final String categoryName = getProduct['category']['name'] ?? 'No category';

          // Access variations
          final List<dynamic>? variations = getProduct['variations'];
          print("before variations: ${variations}");

          if (variations != null && variations.isNotEmpty) {
            for (final variation in variations) {
              final String variationType = variation['variationType'] ?? 'No Type';
              final String variationValue = variation['variationValue'] ?? 'No Value';
              final String sizeUnit = variation['sizeUnit'] ?? 'No Unit';
            }
          } else {
            print('No variations available');
          }

          // Access finalProducts
          final List<dynamic> finalProducts = getProduct['finalProducts'];
          final List<dynamic> reviews = getProduct['reviews'];

          // Extract gallery images
          List<String> galleryImages = [];
          for (var finalProduct in finalProducts) {
            if (finalProduct['galleryImages'] != null) {
              for (var galleryImage in finalProduct['galleryImages']) {
                galleryImages.add(galleryImage['imageUrl']);
              }
            }
          }

          print("Gallery Images: $galleryImages");

          productModel myProduct = productModel(
            id,
            imageUrl,
            name,
            lowestCustomPrice, // Pass the nullable double
            averageRating.toDouble(), // Pass the nullable double
            finalProducts: finalProducts,
            ratingCount: ratingCount,
            description: description,
            variations: variations,
            handcrafterName: handcrafterName,
            reviews: reviews,
            category: categoryName,
            galleryImg: galleryImages,
          );

          return myProduct;
        } else {
          print('getProduct is null');
          return productModel(" ", " ", " ", 0.0, 0.0); // Provide default values
        }
      } else {
        print('Failed to load product: ${response.statusCode}');
        return productModel(" ", " ", " ", 0.0, 0.0); // Provide default values
      }
    } catch (e) {
      print('Error fetching product: $e');
      return productModel(" ", " ", " ", 0.0, 0.0); // Provide default values
    }
  }
  Future<List<productModel>> getHandcrafterProduct() async{
    List<productModel> handcrafterProducts = [];
    final String viewerId = await token.getUUID('SELECT UUID FROM TOKENS');
    String Query = '''
    query User {
    user(id:"${viewerId}") {
        products {
            imageUrl
            averageRating
            category {
                name
            }
            name
            lowestCustomPrice
            id
        }
    }
}
    ''';
    final request = {
      'query': Query,
      'variables': {
        'viewerId': viewerId,
      },
    };

    try{
      final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode(request),
      );
print(response.statusCode);
      if(response.statusCode == 200){
        final Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> getProducts = data['data']?['user']['products'];
        print(data);

        for(var product in getProducts){
          productModel myProduct = productModel(product['id'], product['imageUrl'],
              product['name'], product['lowestCustomPrice'].toDouble(), product['averageRating'].toDouble(), category: product['category']['name']);
          handcrafterProducts.add(myProduct);
        }
        print(handcrafterProducts);
        return handcrafterProducts;

      }else{
        print("Error Happen During Fetching");
        return [];
      }


    }catch (e) {
      print('Error fetching product: $e');
      return []; // Provide default values
    }


  }

  Future<List<productModel>> getAddedProducts(List<String> productIds) async {
    List<productModel> products= [] ;
    Map<String, List<dynamic> > variations= {} ;


    const String query = '''
    query GetProductsByIds(\$productIds: [String!]!) {
      getProductsByIds(productIds: \$productIds) {
         finalProducts {
         id
            finalProductVariation {
                productVariation {
                    variationValue
                }
            }
        }
        category {
            name
        }
        id
        imageUrl
        name
        lowestCustomPrice
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
      // print(response.body);

      // Step 6: Handle the response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> prods = data['data']['getProductsByIds'];
        for(var pro in prods){
// print(pro['finalProducts'][0]['finalProductVariation']);
          List<String> vars = [];
          variations = {};

          for(var finalVariations in pro['finalProducts']){
            vars = [];
            for(var finalVariation in finalVariations['finalProductVariation']){
              vars.add(finalVariation['productVariation']['variationValue']);
            }
            variations[finalVariations['id']] = vars;

          }

          products.add(productModel(pro['id'], pro['imageUrl'], pro['name'],
              pro['lowestCustomPrice'].toDouble(), 0 , category: pro['category']['name'],
              variationsWithIds: variations), );
        }
        print("Products fetched successfully: ${products[0].variationsWithIds}");
        return products;
      } else {
        throw Exception('Failed to load products: ${response.body}');
      }
    } catch (e) {
      print("Error fetching products: $e");
      return products;
    }
  }
  Future<List<productModel>> getBazarProducts() async {
    List<productModel> products= [] ;


    const String query = '''
   query GetBazzarProducts {
    getBazzarProducts(bazarId: "550e8400-e29b-41d4-a716-446655440000") {
        product {
            imageUrl
            id
            product {
                category {
                    name
                }
                name
                averageRating
            }
        }
        bazarPrice
    }
}

  ''';

    final request = {
      'query': query,
      'variables': {
        'bazarId': "550e8400-e29b-41d4-a716-446655440000",
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
        List<dynamic> prods = data['data']['getBazzarProducts'];
        for(var pro in prods){
          products.add(productModel(pro['product']['id'], pro['product']['imageUrl'],
              pro['product']['product']['name'],pro['bazarPrice'].toDouble(), pro['product']['product']['averageRating'].toDouble(),
              category: pro['product']['product']['category']['name']));
        }

        print("Products fetched successfully: $prods");
        return products;
      } else {
        throw Exception('Failed to load products: ${response.body}');
      }
    } catch (e) {
      print("Error fetching products: $e");
      return products;
    }
  }
  Future<List<List<String>>> getFinalProductVariations(String productId) async {
    List<List<String>> variations = [];

    String query = '''
    query GetProductsByIds {
      getProductsByIds(
        productIds:  "$productId"
      ) {
        finalProducts {
            finalProductVariation {
                productVariation {
                    variationValue
                }
            }
        }
      }
    }
  ''';

    final request = {
      'query': query,
      'variables': {
        'productIds': productId,
      },
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
      print(response.body)
;
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        print("//////////////////////////////////////////");
        print(productId);
        print(data['getProductsByIds']);
        print(data);
        for (var variation in data['getProductsByIds']['finalProducts']['finalProductVariation']){
            variations.add(variation['productVariation']['variationValue']);
        }


        return variations;
      } else {
        print('getProduct is null');
        return []; // Provide default values
      }
    }catch (e) {
      print('Error fetching product: $e');
      return[];
    }
    }
//   Future<List<productModel>> addProductsToBazar(List<dynamic> products) async {
//     List<productModel> products= [] ;
//     Map<String, List<dynamic> > variations= {} ;
//     int offer = 0;
//
//
//     const String query = '''
//
// mutation AssignProductsToBazar {
//     assignProductsToBazar(
//         data: { bazarId: "550e8400-e29b-41d4-a716-446655440000", offerPercentage: ${offer}, productId: null, quantity: null }
//     )
// }
//
//   ''';
//
//     final request = {
//       'query': query,
//       'variables': {
//         'bazarId': "550e8400-e29b-41d4-a716-446655440000",
//
//       },
//     };
//
//     try {
//       final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');
//
//       // Step 5: Send the request
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $myToken',
//         },
//         body: jsonEncode(request),
//       );
//
//       // Debug: Print the response body
//       // print(response.body);
//
//       // Step 6: Handle the response
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         List<dynamic> prods = data['data']['getProductsByIds'];
//         for(var pro in prods){
// // print(pro['finalProducts'][0]['finalProductVariation']);
//           List<String> vars = [];
//           variations = {};
//
//           for(var finalVariations in pro['finalProducts']){
//             vars = [];
//             for(var finalVariation in finalVariations['finalProductVariation']){
//               vars.add(finalVariation['productVariation']['variationValue']);
//             }
//             variations[finalVariations['id']] = vars;
//
//           }
//
//           products.add(productModel(pro['id'], pro['imageUrl'], pro['name'],
//               pro['lowestCustomPrice'].toDouble(), 0 , category: pro['category']['name'],
//               variationsWithIds: variations), );
//         }
//         print("Products fetched successfully: ${products[0].variationsWithIds}");
//         return products;
//       } else {
//         throw Exception('Failed to load products: ${response.body}');
//       }
//     } catch (e) {
//       print("Error fetching products: $e");
//       return products;
//     }
//   }

  }


