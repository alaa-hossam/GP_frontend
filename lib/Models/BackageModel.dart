import 'dart:convert';

import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:http/http.dart' as http ;

class Backages{
  double price , duration;
  String name , description;

  Backages(this.price, this.duration, this.name, this.description);

}


class BackagesServices{
  final String apiUrl =
      "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();
  Future<List<Backages>> getBackages()async{
    List<Backages> returnedBackages=[];
    String query = '''
    query GetAdvertisementPackages {
    getAdvertisementPackages(activeOnly: true) {
        actualPrice
        description
        duration
        name
    }
}

    ''';

    final request = {
      'query': query,
    };
    try{
      final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');

      final respone = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode(request));
      List<dynamic> myBackages = jsonDecode(respone.body)['data']['getAdvertisementPackages'];
      for(var backage in myBackages){
        returnedBackages.add(Backages(backage['actualPrice'].toDouble() ,
            backage['duration'].toDouble() , backage['name'] , backage['description']));
      }
      return returnedBackages;
    }catch(e){
      print("error in getting packages: ${e}");
      return [];
    }
  }
}