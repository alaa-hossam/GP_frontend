import 'dart:convert';
import 'package:http/http.dart' as http;
import '../SqfliteCodes/Token.dart';

class generateImageModel {
  String prompt;
  String imageUrl;
  bool isLoading;

  generateImageModel({required this.prompt, required this.imageUrl, this.isLoading = false});
}


class generateImageServices {
  final String apiUrl = "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();

  Future<String> generateImage(String prompt) async {
    print("=====================================================$prompt");
    final request = {
      'query': '''
      mutation GenerateImage {
          generateImage(
          input: { 
          prompt: "${prompt}"
           })
      }
    ''',
    };

    try {
      final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');
      print("Token retrieved: $myToken");
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode(request),
      );

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['errors'] != null) {
          return data['errors'][0]['message']; // Return error message
        }

        // Extract the generated image URL
        final imageUrl = data['data']?['generateImage'];
        if (imageUrl != null && imageUrl.isNotEmpty) {
          print(imageUrl);
          return imageUrl;
        } else {
          return "Invalid prompt. Please try again.";
        }
      } else {
        return jsonDecode(response.body)['errors'][0]['message'];
      }
    } catch (e) {
      print("Exception: $e");
      return "An error occurred: $e";
    }
  }

  Future<String> saveGeneratedImage(generateImageModel generatedImage) async {
    final request = {
      'query': '''
      mutation SaveGeneratedImage {
        saveGeneratedImage(
          input: {
            fileName: "${generatedImage.prompt}", 
            imageUrl: "${generatedImage.imageUrl}"
          }
        )
      }
    ''',
    };

    try {
      final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');
      print("Token retrieved: $myToken");
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken'},
        body: jsonEncode(request),
      );

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['errors'] != null) {
          return data['errors'][0]['message'];
        }

        // Extract the saved image URL correctly
        final imageUrl = data['data']?['saveGeneratedImage'];
        if (imageUrl != null && imageUrl.isNotEmpty) {
          return imageUrl;
        } else {
          return "Failed to save image. Please try again.";
        }
      } else {
        return jsonDecode(response.body)['errors'][0]['message'];
      }
    } catch (e) {
      print("Exception: $e");
      return "An error occurred: $e";
    }
  }
}