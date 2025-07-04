import 'dart:convert';

import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import '../SqfliteCodes/Token.dart';

class orderModel {
  String? addressId, offerId, userId, transactionId;
  List<Map<String, dynamic>>? products;

  orderModel(
      {this.addressId,
      this.offerId,
      this.userId,
      this.transactionId,
      this.products});
}

class orderService {
  final String apiUrl =
      "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();

  Future<String> createOrderByPost(orderModel order) async {
    String query = '''
    mutation CreatePostCustomizedOrder {
    createPostCustomizedOrder(
        input: { addressId: "${order.addressId}", offerId: "${order.offerId}", transactionId: "${order.transactionId}", userId: "${order.userId}" }
    ) {
        id
    }
}
    ''';

    final request = {
      'query': query,
      'variables': {
        'addressId': order.addressId,
        'offerId': order.offerId,
        'transactionId': order.transactionId,
        'userId': order.userId
      }
    };

    try {
      final myToken = await token.getToken();
      print("Token retrieved: $myToken");
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode(request),
      );
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        return "order Created Successfully";
      }
      return "Failed to create order";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> createReadyOrder(
      orderModel order, String giftCode, bool fromBazar) async {
    List<String> itemsString = [];

    if (order.products != null) {
      for (var product in order.products!) {
        itemsString.add('''
        {
          isBazarProduct: ${fromBazar.toString().toLowerCase()},
          productId: "${product['finalId']}",
          quantity: ${product['quantity']}
        }
      ''');
      }
    }

    String query = '''
    mutation CreateReadyMadeOrder {
      createReadyMadeOrder(
        input: {
          addressId: "${order.addressId}"
          giftCode: "$giftCode"
          items: [${itemsString.join(',')}]
          transactionId: "${order.transactionId}"
          userId: "${order.userId}"
        }
      ) {
        actualPrice
      }
    }
  ''';

    print(query);

    try {
      final myToken = await token.getToken();
      print("Token retrieved: $myToken");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode({'query': query}),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        return "Order created successfully";
      } else {
        return "Failed to create order: ${response.body}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<String> createCustomOrder(
      orderModel order, String giftCode, bool fromBazar) async {
    String query = '''
   mutation CreateCustomMadeOrder {
    createCustomMadeOrder(
        input: {
            addressId: "${order.addressId}"
            giftCode: "$giftCode"
            productId: "${order.products![0]['finalId']}"
            quantity: ${order.products![0]['quantity']}
            transactionId: "${order.transactionId}"
            userId: "${order.userId}"
        }
    ){
            id
}
}

  ''';

    try {
      final myToken = await token.getToken();
      print("Token retrieved: $myToken");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode({'query': query}),
      );

      if (response.statusCode == 200) {
        return "Order created successfully";
      } else {
        return "Failed to create order: ${response.body}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    List<Map<String, dynamic>> orders = [];

    Token token = Token();
    String id = await token.getUUID() ?? "";

    String query = '''
 query ClientOrders {
    clientOrders(
        clientId: "${id}"
            ) {
        id
        actualPrice
        createdAt
        customMadeDetails {
            priceAtPurchase
            finalProduct {
                imageUrl
                product {
                id
                    name
                    handicrafter {
                        handicrafterProfile {
                            name
                            imageUrl
                        }
                    }
                    imageUrl
                }
                finalProductVariation {
                    productVariation {
                        variationType
                        variationValue
                    }
                }
            }
        }
        readyMadeDetails {
            finalProduct {
                finalProductVariation {
                    productVariation {
                        variationType
                        variationValue
                    }
                }
                product {
                id
                    name
                    imageUrl
                    handicrafter {
                        handicrafterProfile {
                            name
                            imageUrl
                        }
                    }
                }
            }
            bazarProduct {
                bazarPrice
                product {
                id
                    imageUrl
                    product {
                        name
                    }
                    finalProductVariation {
                        productVariation {
                            variationType
                            variationValue
                        }
                    }
                }
            }
            priceAtPurchase
            quantity
        }
        orderType
        postCustomizedDetails {
            onePrice
            quantity
            approvedOffer {
                handicrafter {
                    handicrafterProfile {
                        imageUrl
                        name
                    }
                }
                post {
                    title
                    gallery {
                        fileURL
                    }
                }
            }
        }
        status
    }
}

  ''';

    final request = {
      'query': query,
      'variables': {
        'clientId': id,
      }
    };

    try {
      final myToken = await token.getToken();
      print("Token retrieved: $myToken");

      print(id);
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

        final result = data['data']['clientOrders'];
        for (var order in result) {
          double price = order['actualPrice'].toDouble();
          if (order['orderType'] == "ReadyMade") {
            int quantity = 0;
            List<productModel> products = [];
            for (var finalProduct in order['readyMadeDetails']) {
              quantity += finalProduct['quantity'] as int;
              List<Map<String, dynamic>> variations = [];
              print(finalProduct['finalProduct']['finalProductVariation']);
              for (var variation in finalProduct['finalProduct']
                  ['finalProductVariation']) {
                variations.add({
                  'variationType': variation['productVariation']
                      ['variationType'],
                  'variationValue': variation['productVariation']
                      ['variationValue']
                });
              }
              products.add(
                productModel(
                  finalProduct['finalProduct']['product']['id'],
                  finalProduct['finalProduct']['product']['imageUrl'],
                  finalProduct['finalProduct']['product']['name'],
                  finalProduct['priceAtPurchase'].toDouble(),
                  0,
                  variations: variations,
                  Quantity: finalProduct['quantity'],
                  handcrafterName: finalProduct['finalProduct']['product']
                      ['handicrafter']['handicrafterProfile']['name'],
                  handcrafterImage: finalProduct['finalProduct']['product']
                      ['handicrafter']['handicrafterProfile']['imageUrl'],
                ),
              );
            }
            orders.add({
              'id': order['id'],
              'orderPrice': price,
              'date': order['createdAt'],
              'quantity': quantity,
              'products': products,
              'status': order['status'],
              'type': order['orderType']
            });
          } else if (order['orderType'] == "PostCustomized") {
            int quantity = order['postCustomizedDetails']['quantity'];

            productModel product = productModel(
              "",
              order['postCustomizedDetails']['approvedOffer']['post'] != null &&
                      order['postCustomizedDetails']['approvedOffer']['post']
                              ['gallery'] !=
                          null
                  ? order['postCustomizedDetails']['approvedOffer']['post']
                      ['gallery'][0]['fileURL']
                  : "",
              order['postCustomizedDetails']['approvedOffer']['post'] != null
                  ? order['postCustomizedDetails']['approvedOffer']['post']
                      ['title']
                  : "",
              order['postCustomizedDetails']['onePrice'].toDouble(),
              0,
              handcrafterName: order['postCustomizedDetails']['approvedOffer']
                      ['handicrafter']['handicrafterProfile']['name'] ??
                  "",
              handcrafterImage: order['postCustomizedDetails']['approvedOffer']
                      ['handicrafter']['handicrafterProfile']['imageUrl'] ??
                  "",
            );

            orders.add({
              'id': order['id'],
              'orderPrice': price,
              'date': order['createdAt'],
              'quantity': quantity,
              'products': product,
              'status': order['status'],
              'type': order['orderType']
            });
          } else if (order['orderType'] == "CustomMade") {
            int quantity = 1;
            List<Map<String, dynamic>> variations = [];
            for (var variation in order['customMadeDetails']['finalProduct']
                ['finalProductVariation']) {
              variations.add({
                'variationType': variation['variationType'],
                'variationValue': variation['variationValue']
              });
            }

            productModel product = productModel(
                order['customMadeDetails']['finalProduct']['product']['id'],
                order['customMadeDetails']['finalProduct']['product']
                    ['imageUrl'],
                order['customMadeDetails']['finalProduct']['product']['name'],
                order['customMadeDetails']['priceAtPurchase'].toDouble(),
                0,
                handcrafterName: order['customMadeDetails']['finalProduct']
                    ['product']['handicrafter']['handicrafterProfile']['name'],
                handcrafterImage: order['customMadeDetails']['finalProduct']
                        ['product']['handicrafter']['handicrafterProfile']
                    ['imageUrl'],
                variations: variations);
            orders.add({
              'id': order['id'],
              'orderPrice': price,
              'date': order['createdAt'],
              'quantity': quantity,
              'products': product,
              'status':order['status'],
              'type': order['orderType']
            });
          }
          print(orders);
        }

        return orders;
      } else {
        return orders;
      }
    } catch (e) {
      print("error : ${e}");
      return orders;
    }
  }
}
