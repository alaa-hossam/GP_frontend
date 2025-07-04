import 'dart:convert';

import 'package:http/http.dart' as http;

import '../SqfliteCodes/Token.dart';

class offerModel{
  String? profileImage , name , createdAt, description , id , handcrafterId;
  int? duration;
  double? price;

  offerModel(
      {this.profileImage,
      this.name,
      this.createdAt,
      this.description,
      this.duration,
      this.price,
      this.id,
      this.handcrafterId});
}

class offerService{
  final String apiUrl =
      "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();

  Future<List<offerModel>> getOffers(String postID)async{
    List<offerModel> offers = [];
    String query = '''
    query ListOffersForPost {
    listOffersForPost(postId: "$postID") {
         description
        createdAt
        id
        handicrafter {
            handicrafterProfile {
                imageUrl
                name
            }
            id
        }
        suggestedOneDuration
        suggestedOnePrice
    }
}

    ''';

    final request = {
      'query': query,
      'variable':{
        'postId':postID
      }

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
      print(postID);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> offersData = data['data']['listOffersForPost'];
        for(var offer in offersData){
          offers.add(offerModel(createdAt: offer['createdAt'],duration: offer['suggestedOneDuration'],
          price: offer['suggestedOnePrice'].toDouble(),description: offer['description'],
            name: offer['handicrafter']['handicrafterProfile']['name'],
              profileImage: offer['handicrafter']['handicrafterProfile']['imageUrl'],
            id: offer['id'], handcrafterId: offer['handicrafter']['id']
          ));
        }

        return offers;

      } else {
        print('Failed to load offers: ${response.statusCode}');
      }
      return offers;
    } catch (e) {
      print('Error fetching offers: $e');
      return offers;
    }
  }
  Future<bool> addOffer(offerModel offer , String postId)async{
    Token token = Token();
    final String handcrafterId = await token.getUUID() ?? "";
    String query = '''
    mutation CreateOffer {
    createOffer(
        data: { description: "${offer.description}", suggestedOneDuration: ${offer.duration}, suggestedOnePrice: ${offer.price} }
        handicrafterId: "$handcrafterId"
        postId: "$postId"
    ) {
        id
    }
}
''';
    final request = {
      'query': query,
      'variables': {
        'description':offer.description,
        'suggestedOnePrice':offer.price,
        'handicrafterId':handcrafterId,
        'postId' :postId
      },
    };
    try{
      final myToken = await token.getToken();
      final response = await http.post(
          Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode(request)
      );
      print(response.body);
      if(response.statusCode == 200){
        return true;
      }
      return false;
    }catch(e){
      return false;
    }
  }

  Future<bool> updateOffer(offerModel offer)async{
    Token token = Token();
    String query = '''
    mutation UpdateOffer {
    updateOffer(
        data: { description: "${offer.description}", suggestedOneDuration: ${offer.duration}, suggestedOnePrice: ${offer.price} }
        offerId: "${offer.id}"
        userId: "${offer.handcrafterId}"
    ) {
        id
    }
}

''';
    final request = {
      'query': query,
      'variables': {
        'description':offer.description,
        'suggestedOnePrice':offer.price,
        'suggestedOneDuration':offer.duration,
        'offerId' :offer.id,
        'userId':offer.handcrafterId
      },
    };

    print("reeeeeeeeeeeeeeeeq");
    print(request);
    try{
      final myToken = await token.getToken();
      final response = await http.post(
          Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode(request)
      );
      print(response.body);
      if(response.statusCode == 200){
       print("offer Updated Successfully");
       return true;
      }
      print("offer failed to update");
      return false;
    }catch(e){
      print("offer failed to Update");
      return false;
    }
  }
  Future<bool> deleteOffer(String offerId)async{
    Token token = Token();
    String query = '''
   mutation DeleteOffer {
    deleteOffer(offerId: "${offerId}")
}


''';
    final request = {
      'query': query,
      'variables': {
        'offerId':offerId,

      },
    };

    try{
      final myToken = await token.getToken();
      final response = await http.post(
          Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode(request)
      );
      print(response.body);
      if(response.statusCode == 200){
       print("offer deleted Successfully");
       return true;
      }
      print("offer failed to deleted");
      return false;
    }catch(e){
      print("offer failed to deleted");
      return false;
    }
  }
}