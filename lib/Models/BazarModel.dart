import 'dart:convert';

import 'package:http/http.dart' as http;

import '../SqfliteCodes/Token.dart';
import 'ProductModel.dart';

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

  Future<List<productModel>> getBazarProducts(String id) async {
    List<productModel> products= [] ;


    String query = '''
   query GetBazzarProducts {
    getBazzarProducts(bazarId: "$id") {
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
        'bazarId': id,
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



}