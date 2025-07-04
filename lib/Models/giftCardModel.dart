import 'dart:convert';

import 'package:http/http.dart' as http;

import '../SqfliteCodes/Token.dart';

class giftCardModel {
  String mail, message;
  double amount;

  giftCardModel(
      {required this.mail, required this.amount, required this.message});
}

class giftCardService {
  final String apiUrl =
      "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();

  Future<String> buyGiftCard(
    giftCardModel card,
    String transactionId,
  ) async {
    final userId = await token.getUUID();
    final myToken = await token.getToken();

    final request = {
      'query': '''
           mutation BuyGiftCard {
    buyGiftCard(
        data: {
         amount: ${card.amount}, 
         message: "${card.message}", 
         recipientEmail: "${card.mail}",
          transactionId: "${transactionId}" ,
          }
        senderId: "${userId}"
    ) {
        id
    }
}
        ''',
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode(request),
      );

      print("Response: ${response.body}"); // Debugging the response

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['errors'] != null) {
          return data['errors'][0]['message'];
        }
        return "card bought successfully";
      } else {
        return jsonDecode(response.body)['errors'][0]['message'];
      }
    } catch (e) {
      print("Exception: $e");
      return e.toString();
    }
  }
}
