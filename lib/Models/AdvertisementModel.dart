import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:gp_frontend/SqfliteCodes/Token.dart';

class AdvertisementsModel {
  String? link,Package, transaction, imageUrl , id;
  File? image;

  AdvertisementsModel({this.imageUrl, this.link, this.Package , this.transaction ,this.id, this.image});
}

class AdvertisementApiServices {
  final String apiUrl =
      "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();

  Future<String> addAdvertisement(File? image, String? url, String? packageId, String? transactionId) async {
    Token tokenTable = Token();
    String id = await tokenTable.getUUID("SELECT UUID FROM TOKENS");
    String myToken = await tokenTable.getToken('SELECT TOKEN FROM TOKENS');

    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add headers
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['x-apollo-operation-name'] = 'CreateAdvertisement';
      request.headers['Authorization'] = 'Bearer $myToken';

      // Add the GraphQL query as a field
      request.fields['operations'] = jsonEncode({
        "query": """
        mutation CreateAdvertisement(\$file: Upload!, \$advUrl: String!, \$clientId: String!, \$packageId: String!, \$transactionId: String!) {
          createAdvertisement(
            createAdvertisementDto: {
              advUrl: \$advUrl
              clientId: \$clientId
              packageId: \$packageId
              transactionId: \$transactionId
            }
            file: \$file
          ) {
            imageUrl
          }
        }
      """,
        "variables": {
          "file": null,
          "advUrl": url,
          "clientId": id,
          "packageId": "550e8400-e29b-41d4-a716-446655440080",
          "transactionId": "550e8400-e29b-41d4-a716-446655440080"
        }
      });

      // Add the file map
      request.fields['map'] = jsonEncode({
        "0": ["variables.file"]
      });

      // Add the actual file
      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          '0',
          image.path,
        ));
      }

      // Send the request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
print(responseBody);
      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        if (data['errors'] != null) {
          throw Exception('GraphQL Error: ${data['errors'][0]['message']}');
        }
        return "Advertisement Added Successfully";
      } else {
        throw Exception('Failed to create Advertisement: ${response.statusCode} - $responseBody');
      }
    } catch (e) {
      return "Error creating Advertisement: $e";
    }
  }

  Future<List<AdvertisementsModel>> getAds() async {
    List<AdvertisementsModel> advertisements= [] ;


    const String query = '''
  query GetHomePageAdv {
    getHomePageAdv {
        advUrl
        imageUrl
        id
    }
}

  ''';

    final request = {
      'query': query,
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


      // Step 6: Handle the response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> ads = data['data']['getHomePageAdv'];
        for(var ad in ads){
          advertisements.add(AdvertisementsModel(imageUrl: ad['imageUrl'] ,link: ad['advUrl'],id: ad['id'] ));
        }

        // print("Advertisement fetched successfully: $ads");
        print("Advertisement fetched successfully: $advertisements");
        return advertisements;
      } else {
        throw Exception('Failed to load products: ${response.body}');
      }
    } catch (e) {
      print("Error fetching products: $e");
      return advertisements;
    }
  }


}

