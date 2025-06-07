import 'dart:convert';

import 'package:http/http.dart' as http;

import '../SqfliteCodes/Token.dart';

class offerModel{
  String? profileImage , name , createdAt, description;
  int? duration;
  double? price;

  offerModel(
      {this.profileImage,
      this.name,
      this.createdAt,
      this.description,
      this.duration,
      this.price});
}

class offerService{
  final String apiUrl =
      "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();

  Future<List<offerModel>> getOffers(String postID)async{
    List<offerModel> offers = [];
    String query = '''
    query ListOffersForPost {
    listOffersForPost(postId: "550e8400-e29b-41d4-a716-446655440030") {
        comments {
            content
            offer {
                suggestedOneDuration
                suggestedOnePrice
            }
        }
        handicrafter {
            clientProfile {
                imageUrl
                name
            }
            createdAt
        }
    }
}

    ''';

    final request = {
      'query': query,

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
      print(response.body);

      if (response.statusCode == 200) {


      } else {
        print('Failed to load offers: ${response.statusCode}');
      }
      return offers;
    } catch (e) {
      print('Error fetching offers: $e');
      return offers;
    }
  }
}