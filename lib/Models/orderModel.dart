import 'dart:convert';

import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:http/http.dart' as http;

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

    print(request);

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

  Future<String> createReadyOrder(orderModel order, String giftCode, bool fromBazar) async {
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
      final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');
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
  Future<String> createCustomOrder(orderModel order, String giftCode, bool fromBazar) async {

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
      final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');
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
}
