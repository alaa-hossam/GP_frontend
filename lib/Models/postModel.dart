import 'dart:convert';
import 'dart:io';

import 'package:gp_frontend/Models/specializationModel.dart';
import 'package:http/http.dart' as http;

import '../SqfliteCodes/Token.dart';




// mutation CreatePost {
// createPost(
// data: {
// customerId: null
// description: null
// fileType: Image
// images: null
// specializationId: null
// suggestedOneDuration: null
// suggestedOnePrice: null
// suggestedQuantity: null
// title: null
// type: General
// }
// )
// }

class postModel{
  String userName , clientImage , description , postImage, title;
  int quantity , duration;
  double  price;

  postModel(this.userName, this.clientImage, this.description, this.postImage,
      this.quantity, this.duration, this.price ,this.title);
}


class postService{
  final String apiUrl =
      "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();

  Future<List<postModel>> getPosts() async {
    final viewerId = await token.getUUID('SELECT UUID FROM TOKENS');
    List<postModel> posts = [];
    String query = '''
    query GetPostsByClient {
    getPostsByClient(clientId: "${viewerId}") {
        customer {
            username
            clientProfile {
                imageUrl
            }
        }
        description
        gallery {
            fileURL
        }
        suggestedOneDuration
        suggestedOnePrice
        suggestedQuantity
    }
}
  ''';

    final request = {
      'query': query,
      'variables': {
        'viewerId': viewerId,
      },
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
        final Map<String, dynamic> data = jsonDecode(response.body);

        final List<dynamic> getPosts = data['data']['getPostsByClient'];
        for(var post in getPosts){
          posts.add(postModel(post['customer']['username'] ?? "" ,
              post['customer']['clientProfile'] ?? "assets/images/Frame 36920.png" ,
              post['description'], post['gallery']['fileURL'] ?? "assets/images/Frame 36920.png"
              , post['suggestedQuantity'], post['suggestedOneDuration'], post['suggestedOnePrice'].toDouble(), post['title'] ?? ""));
        }
        } else {
        print('Failed to load product: ${response.statusCode}');
      }
      return posts;
    } catch (e) {
      print('Error fetching product: $e');
      return posts;
    }
  }



  Future<String> addPost(postModel order, String specializationId, File? image) async {
    Token tokenTable = Token();
    String id = await tokenTable.getUUID("SELECT UUID FROM TOKENS");
    String myToken = await tokenTable.getToken('SELECT TOKEN FROM TOKENS');

    final apiUrl = 'YOUR_API_ENDPOINT_HERE'; // Replace with actual URL

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add headers
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['x-apollo-operation-name'] = 'CreatePost';
      request.headers['Authorization'] = 'Bearer $myToken';

      // Define the GraphQL operation with variables
      final operations = {
        "query": """
        mutation CreatePost(\$file: Upload!) {
          createPost(
            data: {
              customerId: "$id",
              description: "${order.description}",
              fileType: Image,
              images: \$file
              specializationId: "$specializationId",
              suggestedOneDuration: ${order.duration},
              suggestedOnePrice: ${(order.price).toDouble()},
              suggestedQuantity: ${order.quantity},
              title: "${order.title}",
              type: General
            }
          ){
        id
    }
        }
      """,
        "variables": {
          "file": null
        }
      };

      request.fields['operations'] = jsonEncode(operations);

      // Map the file to the variable
      request.fields['map'] = jsonEncode({
        "0": ["variables.file"]
      });

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          '0',
          image.path,
        ));
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Status Code: ${response.statusCode}');
      print('Response Body: $responseBody');

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





}