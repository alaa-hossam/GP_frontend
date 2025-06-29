import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../SqfliteCodes/Token.dart';



class postModel{
  String? userName , clientImage , description , postImage, title, createdAt, id, clientId;
  int? quantity , duration;
  double?  price;
  List<String>? offersIds;

  postModel(
      {
        this.clientId,
        this.id,
        this.userName,
        this.clientImage,
        this.description,
        this.postImage,
        this.quantity,
        this.duration,
        this.price,
        this.title,
        this.createdAt,
        this.offersIds});
}


class postService{
  final String apiUrl =
      "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();

  Future<List<postModel>> getClientPosts() async {
    final viewerId = await token.getUUID();
    List<postModel> posts = [];
    String query = '''
    query GetPostsByClient {
    getPostsByClient(clientId: "${viewerId}") {
        customer {
        id
            username
            clientProfile {
                imageUrl
            }
        }
        id
        createdAt
        description
        gallery {
            fileURL
        }
        
       offers {
            id
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
      final myToken = await token.getToken();
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode(request),
      );


      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final List<dynamic> getPosts = data['data']['getPostsByClient'];

        for(var post in getPosts){
          List<String>? ids = [];
          for(var offer in post['offers']){
            if(post['offers'] != null){
              ids.add(offer['id']);
            }
          }
          posts.add(postModel(userName: post['customer']['username'] ?? "" ,
              clientImage:post['customer']['clientProfile'],
              id: post['id'],
              description: post['description'],postImage:  post['gallery'][0]['fileURL']
              ,quantity:post['suggestedQuantity'],duration:post['suggestedOneDuration']
              , price: post['suggestedOnePrice'].toDouble(),
              title:  post['title'] ?? "" , createdAt: post['createdAt'],
              offersIds: ids, clientId: post['customer']['id']

          ));
          print("****************************************");
          print(post['customer']['id']);

        }

        return posts;

        } else {
        print('Failed to load product: ${response.statusCode}');
      }
      return posts;
    } catch (e) {
      print('Error fetching product: $e');
      return posts;
    }
  }

  Future<List<postModel>> getAllPosts() async {
    final viewerId = await token.getUUID();
    List<postModel> posts = [];
    String query = '''
   query GetPosts {
    getPosts {
        description
        suggestedOnePrice
        suggestedQuantity
        title
        id
        offers {
            id
        }
        suggestedOneDuration
        createdAt
        customer {
        id
            username
            clientProfile {
                imageUrl
            }
        }
        gallery {
            fileURL
        }
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
      final myToken = await token.getToken();
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode(request),
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final List<dynamic> getPosts = data['data']['getPosts'];

        for(var post in getPosts){
          List<String>? ids = [];
            if(post['offers'] != null){
              for(var offer in post['offers']){
                ids.add(offer['id']);
            }
          }
          posts.add(postModel(userName: post['customer']['username'] ?? "" ,
              clientImage:post['customer']['clientProfile'],
              description: post['description'],postImage:  post['gallery'][0]['fileURL']
              ,quantity:post['suggestedQuantity'],duration:post['suggestedOneDuration']
              , price: post['suggestedOnePrice'].toDouble(),
              id:  post['id'],
              title:  post['title'] ?? "" , createdAt: post['createdAt'],
              offersIds: ids,clientId: post['customer']['id']

          ));
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



  Future<String> addPost(postModel post, String specializationId, File? image) async {
    Token tokenTable = Token();
    String id = await tokenTable.getUUID()??"";
    String myToken = await tokenTable.getToken() ?? "";


    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add headers
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['x-apollo-operation-name'] = 'CreatePost';
      request.headers['Authorization'] = 'Bearer $myToken';

      final operations = {
        "query": """
        mutation CreatePost(\$file: Upload!) {
          createPost(
            data: {
              customerId: "$id",
              description: "${post.description}",
              fileType: Image,
              images: [\$file]
              specializationId: "$specializationId",
              suggestedOneDuration: ${post.duration},
              suggestedOnePrice: ${(post.price ?? 0).toDouble()},
              suggestedQuantity: ${post.quantity},
              title: "${post.title}",
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

      request.fields['map'] = jsonEncode({
        "0": ["variables.file"]
      });

      print(image);
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
        return "post Added Successfully";
      } else {
        throw Exception('Failed to create post: ${response.statusCode} - $responseBody');
      }
    } catch (e) {
      return "Error creating Advertisement: $e";
    }
  }





}