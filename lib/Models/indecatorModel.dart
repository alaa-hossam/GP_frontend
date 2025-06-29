import 'dart:convert';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:http/http.dart' as http;

class indicatorModel {
  final String id;
  final String name;
  final String? type;

  indicatorModel({required this.id, required this.name,this.type});
}

class indecatorService {
  final String apiUrl = "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();

  Future<List<indicatorModel>> getAllTags() async {
    List<indicatorModel> indecators = [];
    final request = {
      'query': '''
      query GetAllIndicators {
    getAllIndicators(type: Tag) {
        name
        id
    }
}
      ''',
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
        final data = jsonDecode(response.body);
        List<dynamic> tags = data['data']['getAllIndicators'];
        print(tags);
        indecators.clear();

        for (var tag in tags) {
          indecators.add(indicatorModel(id: tag['id'], name: tag['name']));
        }

        print("Categories fetched successfully: $indecators");
        return indecators;
      } else {
        throw Exception('Failed to load categories: ${response.body}');
      }
    } catch (e) {
      print("Error fetching categories: $e");
      return indecators;
    }
  }


}