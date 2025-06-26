import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:gp_frontend/SqfliteCodes/Token.dart';

class handcrafterPostModel {
  String content, fileURl, id;

  handcrafterPostModel(this.content, this.fileURl, this.id);
}

class handcrafterModel {
  String? name, description , profileURL;
  File? profileImage, nationalIdImage;
  List<String>? specializationsId;
  List<handcrafterPostModel>? posts;

  handcrafterModel(
      {this.name,
       this.profileImage,
        this.profileURL,
       this.description,
      this.specializationsId,
      this.nationalIdImage,
      this.posts,
      });
}

class handcrafterService {
  final String apiUrl =
      "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";

  Future<String> addHandcrafter(handcrafterModel handcrafter) async {
    print("In handcrafterModel ==========");

    // Retrieve the user ID from the token
    Token token = Token();
    final userId = await token.getUUID('SELECT UUID FROM TOKENS');
    if (userId == null) {
      return "Error: User ID not found.";
    }
    final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');
    print("Token in getCartProducts: $myToken");
    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Add headers
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['x-apollo-operation-name'] = 'RequestToBeHandicrafter';
    request.headers['Authorization'] = 'Bearer $myToken';

    // GraphQL query with variables
    final query = '''
      mutation RequestToBeHandicrafter(\$specializationsId: [String!]!, \$profileImage: Upload!, \$nationalIdImage: Upload!) {
        requestToBeHandicrafter(
          createHandicrafterProfileInput: { 
            name: "${handcrafter.name}", 
            specializationsId: \$specializationsId, 
            userId: "$userId",
            description: "${handcrafter.description}"
          }
          profileImage: \$profileImage
          nationalIdImage: \$nationalIdImage
        ) {
          status
        }
      }
    ''';

    // Add the query and variables to the request
    request.fields['operations'] = jsonEncode({
      'query': query,
      'variables': {
        'specializationsId': handcrafter.specializationsId,
        'profileImage': null,
        'nationalIdImage': null,
      },
    });

    // Add the file map
    request.fields['map'] = jsonEncode({
      '0': ['variables.profileImage'],
      '1': ['variables.nationalIdImage'],
    });

    // Add files to the request
    request.files.add(await http.MultipartFile.fromPath(
      '0',
      handcrafter.profileImage!.path,
    ));
    request.files.add(await http.MultipartFile.fromPath(
      '1',
      handcrafter.nationalIdImage!.path,
    ));

    try {
      // Send the request
      final response = await request.send();

      // Read the response
      final responseBody = await response.stream.bytesToString();
      print("Response: $responseBody"); // Debugging the response

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        if (data['errors'] != null) {
          // Handle GraphQL errors
          return data['errors'][0]['message'];
        }
        print(data['data']['requestToBeHandicrafter']['status']);
        return "Handcrafter added successfully";
      } else {
        // Handle HTTP errors
        return "HTTP Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      print("Exception: $e");
      return "An error occurred: $e";
    }
  }

  Future<String> addHandcrafterReel(String content, File file) async {
    print("In handcrafterModel ==========");

    // Retrieve the user ID from the token
    Token token = Token();
    final userId = await token.getUUID('SELECT UUID FROM TOKENS');
    if (userId == null) {
      return "Error: User ID not found.";
    }
    final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');
    print("Token in addHandcrafterReel: $myToken");
    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Add headers
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['x-apollo-operation-name'] = 'CreateHandicrafterPost';
    request.headers['Authorization'] = 'Bearer $myToken';

    // GraphQL query with variables
    final query = '''
    mutation CreateHandicrafterPost (\$file: Upload!) {
    createHandicrafterPost(
        createHandicrafterPostInput: { content: "${content}", handicrafterProfileId: "${userId}" }
        file: \$file
    ) {
        createdAt
    }
}
    ''';

    // Add the query and variables to the request
    request.fields['operations'] = jsonEncode({
      'query': query,
      'variables': {
        'file':null,
      },
    });

    // Add the file map
    request.fields['map'] = jsonEncode({
      '0': ['variables.file'],
    });

    // Add files to the request
    request.files.add(await http.MultipartFile.fromPath(
      '0',
      file.path,
    ));

    try {
      // Send the request
      final response = await request.send();

      // Read the response
      final responseBody = await response.stream.bytesToString();
      print("Response: $responseBody"); // Debugging the response

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        if (data['errors'] != null) {
          // Handle GraphQL errors
          return data['errors'][0]['message'];
        }
        print(data['data']['createHandicrafterPost']['createdAt']);
        return "Handcrafter reel added successfully";
      } else {
        // Handle HTTP errors
        return "HTTP Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      print("Exception: $e");
      return "An error occurred: $e";
    }
  }

  Future<handcrafterModel?> getHandcrafter() async {
    print("get user profile");
    Token token = Token();
    final userId = await token.getUUID('SELECT UUID FROM TOKENS');

    handcrafterModel? handcrafter;
    String query = '''
        query User {
        user(id: "${userId}") {
            handicrafterProfile {
                description
                imageUrl
                name
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
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final getCustomer = data['data']['user']['handicrafterProfile'];
        handcrafter = handcrafterModel(
            name: getCustomer['name'],
            profileURL: getCustomer['imageUrl'],
            description: getCustomer['description']);
        return handcrafter;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return handcrafter;
    }
  }
}
