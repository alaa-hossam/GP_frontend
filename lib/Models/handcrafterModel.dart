import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:gp_frontend/SqfliteCodes/Token.dart';

class handcrafterModel {
  String name, description;
  File profileImage, nationalIdImage;
  List<String> specializationsId;

  handcrafterModel(this.name, this.profileImage, this.description,
      this.specializationsId, this.nationalIdImage);
}

class handcrafterService {
  final String apiUrl =
      "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";

  Future<String> addHandcrafter(handcrafterModel handcrafter) async {
    Token token = Token();
    final userId = await token.getUUID('SELECT UUID FROM TOKENS');

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Add headers
    request.headers['Content-Type'] = 'multipart/form-data';

    // Add fields to the request
    request.fields['query'] = '''
      mutation RequestToBeHandicrafter(\$profileImage: Upload!, \$nationalIdImage: Upload!) {
        requestToBeHandicrafter(
          createHandicrafterProfileInput: { 
            name: "${handcrafter.name}", 
            specializationsId: ${jsonEncode(handcrafter.specializationsId)}, 
            userId: "$userId",
            description: "${handcrafter.description}"
          }
          profileImage: \$profileImage
          nationalIdImage: \$nationalIdImage
        )
      }
    ''';

    // Add files to the request
    request.files.add(await http.MultipartFile.fromPath(
      'profileImage',
      handcrafter.profileImage.path,
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'nationalIdImage',
      handcrafter.nationalIdImage.path,
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
        return "Handcrafter added successfully";
      } else {
        return jsonDecode(responseBody)['errors'][0]['message'];
      }
    } catch (e) {
      print("Exception: $e");
      return e.toString();
    }
  }
}