import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:gp_frontend/SqfliteCodes/Token.dart';

class handcrafterPostModel {
  String content, fileURl, id;

  handcrafterPostModel(this.content, this.fileURl, this.id);
}

class handcrafterAnalysisModel {
  List<Map<String, dynamic>>? customMade;
  List<Map<String, dynamic>>? postCustomized;
  List<Map<String, dynamic>>? readyMade;
  List<Map<String, dynamic>>? visits;
  double? totalCustom;
  double? totalPost;
  double? totalReady;
  int? totalVisit;

  handcrafterAnalysisModel({
    this.customMade,
    this.postCustomized,
    this.readyMade,
    this.visits,
    this.totalCustom,
    this.totalPost,
    this.totalReady,
    this.totalVisit,
  });
}


class handcrafterModel {
  String? name, description, profileURL;
  File? profileImage, nationalIdImage;
  List<String>? specializationsId;
  List<handcrafterPostModel>? posts;
  double? rate;

  handcrafterModel({
    this.name,
    this.profileImage,
    this.profileURL,
    this.description,
    this.specializationsId,
    this.nationalIdImage,
    this.posts,
    this.rate,
  });
}

class handcrafterService {
  final String apiUrl =
      "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";

  Future<String> addHandcrafter(handcrafterModel handcrafter) async {
    print("In handcrafterModel ==========");

    // Retrieve the user ID from the token
    Token token = Token();
    final userId = await token.getUUID();
    if (userId == null) {
      return "Error: User ID not found.";
    }
    final myToken = await token.getToken();
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
    final userId = await token.getUUID();
    if (userId == null) {
      return "Error: User ID not found.";
    }
    final myToken = await token.getToken();
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
        'file': null,
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

  Future<String> changeImageProfile(File file) async {
    print("In handcrafterModel ==========");

    Token token = Token();
    final userId = await token.getUUID();
    if (userId == null) {
      return "Error: User ID not found.";
    }
    final myToken = await token.getToken();
    print("Token in chanfe profile image: $myToken");
    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Add headers
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['x-apollo-operation-name'] = 'ChangeProfileImage';
    request.headers['Authorization'] = 'Bearer $myToken';

    // GraphQL query with variables
    final query = '''
    mutation ChangeProfileImage (\$file: Upload!){
    changeProfileImage(file: \$file, userId: "${userId}") {
        imageUrl
        userId
    }
}
    ''';

    // Add the query and variables to the request
    request.fields['operations'] = jsonEncode({
      'query': query,
      'variables': {
        'file': null,
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
          return data['errors'][0]['message'];
        }
        print(data['data']['changeProfileImage']['imageUrl']);
        return "image changed successfully";
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
    print("Fetching handcrafter reels...");
    Token token = Token();
    final userId = await token.getUUID();

    handcrafterModel? handcrafter;

    String query = '''
    query User {
      user(id: "${userId}") {
        handicrafterProfile {
          name
          description
          averageRating
          posts {
            id
            content
            postFileUrl
          }
        }
         clientProfile {
            imageUrl
        }
      }
    }
  ''';

    final request = {
      'query': query,
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
print(response);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final profile = data['data']['user'];

        List<handcrafterPostModel> postList = [];
        for (var post in profile['handicrafterProfile']['posts']) {
          postList.add(
            handcrafterPostModel(
              post['content'],
              post['postFileUrl'],
              post['id'],
            ),
          );
        }

        handcrafter = handcrafterModel(
          name: profile['handicrafterProfile']['name'],
          profileURL: profile['clientProfile']['imageUrl'],
          description: profile['handicrafterProfile']['description'],
          rate: profile['handicrafterProfile']['averageRating']?.toDouble() ?? 0.0,
          posts: postList,
        );
        print("00000000000000000000000000000000000000000000000000000000000000000000000000000");
        print(profile['imageUrl']);
        print("00000000000000000000000000000000000000000000000000000000000000000000000000000");

        return handcrafter;
      } else {
        print("HTTP Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print('Error fetching handcrafter reels: $e');
    }

    return null;
  }


  Future<handcrafterAnalysisModel?> getHandcrafterAnalysis(String interval) async {
    print("Fetching handcrafter analysis...");
    Token token = Token();
    final userId = await token.getUUID();

    String query = '''
    query GetHandicrafterAnalysis {
      getHandicrafterAnalysis(handicrafterId: "$userId", interval: $interval) {
        totalRevenue {
          customMade {
            data { period revenue }
            total
          }
          postCustomized {
            data { period revenue }
            total
          }
          readyMade {
            data { period revenue }
            total
          }
        }
        profileVisits {
          visitedData { count period }
          totalVisits
        }
      }
    }
  ''';

    final request = {'query': query};

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
        final analysis = data['data']['getHandicrafterAnalysis'];

        final customMadeData = List<Map<String, dynamic>>.from(
            analysis['totalRevenue']['customMade']['data']);
        final postCustomizedData = List<Map<String, dynamic>>.from(
            analysis['totalRevenue']['postCustomized']['data']);
        final readyMadeData = List<Map<String, dynamic>>.from(
            analysis['totalRevenue']['readyMade']['data']);
        final visitsData = List<Map<String, dynamic>>.from(
            analysis['profileVisits']['visitedData']);

        return handcrafterAnalysisModel(
          customMade: customMadeData,
          postCustomized: postCustomizedData,
          readyMade: readyMadeData,
          totalCustom: (analysis['totalRevenue']['customMade']['total'] ?? 0).toDouble(),
          totalPost: (analysis['totalRevenue']['postCustomized']['total'] ?? 0).toDouble(),
          totalReady: (analysis['totalRevenue']['readyMade']['total'] ?? 0).toDouble(),
          visits: visitsData,
          totalVisit: analysis['profileVisits']['totalVisits'],
        );
      } else {
        print("HTTP Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print('Error fetching handcrafter analysis: $e');
    }

    return null;
  }

  Future<handcrafterModel?> getHandcrafterById(String id) async {
    print("Fetching handcrafter reels...");
    Token token = Token();
    final userId = await token.getUUID();
    handcrafterModel? handcrafter;

    String query = '''
    query GetHandicrafterProfile {
    getHandicrafterProfile(handicrafterProfileId: "${id}", viewerId: "${userId}") {
        averageRating
        name
        description
        posts {
            content
            id
            postFileUrl
        }
         user {
            clientProfile {
                imageUrl
            }
        }
    }
}

  ''';

    final request = {
      'query': query,
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

        final profile = data['data']['getHandicrafterProfile'];

        List<handcrafterPostModel> postList = [];
        for (var post in profile['posts']) {
          postList.add(
            handcrafterPostModel(
              post['content'],
              post['postFileUrl'],
              post['id'],
            ),
          );
        }

        handcrafter = handcrafterModel(
          name: profile['name'],
          profileURL: profile['user']['clientProfile']['imageUrl'],
          description: profile['description'],
          rate: profile['averageRating']?.toDouble() ?? 0.0,
          posts: postList,
        );

        return handcrafter;
      } else {
        print("HTTP Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print('Error fetching handcrafter reels: $e');
    }

    return null;
  }

  Future<bool> deleteHandCrafterPost(String postId) async {
    print("delete handcrafter reel...");
    Token token = Token();

    String query = '''
    mutation DeleteHandicrafterPost {
    deleteHandicrafterPost(postId: "${postId}")
}
  ''';

    final request = {
      'query': query,
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
        final output = data['data']['deleteHandicrafterPost'];
        return output;
      } else {
        print("HTTP Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print('Error fetching handcrafter reels: $e');
    }

    return false;
  }


}
