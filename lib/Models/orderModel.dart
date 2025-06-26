import 'dart:convert';

import 'package:http/http.dart' as http;

import '../SqfliteCodes/Token.dart';

class orderModel {
  String? addressId, offerId, userId, transactionId;

  orderModel({this.addressId, this.offerId, this.userId, this.transactionId});
}

class orderService {
  final String apiUrl =
      "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();

  Future<String> createOrderByPost(orderModel order) async{
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
      'variables':{
        'addressId': order.addressId,
        'offerId': order.offerId,
        'transactionId': order.transactionId,
        'userId': order.userId
      }
    };


    try{
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

      if(response.statusCode == 200){
        // final data = jsonDecode(response.body);
        // print(data);
        // List<dynamic> order = data['data']['createPostCustomizedOrder']['id'];
        // print("......................................................................................");
        // print("......................................................................................");
        // return jsonDecode(response.body)['data']['createPostCustomizedOrder']['id'];
        return "order Created Successfully";
      }
      return "Failed to create order";

    }catch(e){
      return e.toString();
    }

  }
}
