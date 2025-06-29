import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';


class SearchServiceAI {


  Future<List<String>> SearchImage(int topK) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    List<String> products = [];

    if (pickedFile == null) {
      print("No image selected");
      return[];
    }

    final uri = Uri.parse("https://squid-app-8tjc4.ondigitalocean.app/api/v1/image/search");

    final request = http.MultipartRequest('POST', uri);

    final imageFile = File(pickedFile.path);
    final fileName = pickedFile.path.split('/').last;
    print(imageFile.path);
    print(fileName);

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType('image', _getImageMimeType(fileName)),
      ),


    );

    request.fields['top_k'] = topK.toString();

    try {

      final response = await request.send();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = await response.stream.bytesToString();
        print(responseBody);
        final data = json.decode(responseBody);

        // print(data['images']);
        for(var product in data['images']){
          products.add(product['id']);
        }
        print("Success! Response: $responseBody");
        return products;
      } else {
        final errorBody = await response.stream.bytesToString();
        print("Failed with status: ${response.statusCode}");
        print("Error response: $errorBody");
        return products;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return products;
    }
  }
}

String _getImageMimeType(String fileName) {
  final extension = fileName.split('.').last.toLowerCase();
  switch (extension) {
    case 'jpg':
    case 'jpeg':
      return 'jpeg';
    case 'png':
      return 'png';
    case 'webp':
      return 'webp';
    default:
      return 'jpeg'; // fallback
  }
}
