import 'dart:convert';

import 'package:http/http.dart' as http;

import '../SqfliteCodes/Token.dart';

class BazarModel{
  String? id;

  BazarModel({this.id});
}

class BazarService{
  final String apiUrl =
      "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();

  Future<BazarModel> getActiveBazar()async{
    BazarModel bazar = BazarModel();

    String query = '''
    query GetActiveBazars {
    getActiveBazars(options: null) {
        id
    
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

      bazar =BazarModel(id: jsonDecode(respone.body)['data']['getActiveBazars'][0]['id']) ;
      return bazar;
    }catch(e){
      print("error in getting packages: ${e}");
      return bazar;
    }

  }


}