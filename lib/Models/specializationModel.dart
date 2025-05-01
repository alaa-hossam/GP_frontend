import 'dart:convert';

import 'package:http/http.dart' as http;

import '../SqfliteCodes/Token.dart';

class specializationModel{
  String id , name;

  specializationModel(this.id, this.name);
}

class specializtionService{

  final String apiUrl =
      "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();

  Future<List<specializationModel>> getSpecialization() async {
    List<specializationModel> specializations = [];

    String query = '''
    query GetAllSpecializations {
    getAllSpecializations {
        id
        name
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
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final List<dynamic> allSpecializtions = data['data']['getAllSpecializations'];
        for(var specialization in allSpecializtions){
          specializations.add(specializationModel(specialization['id'], specialization['name']));
        }
      } else {
        print('Failed to load product: ${response.statusCode}');
      }
      return specializations;
    } catch (e) {
      print('Error fetching product: $e');
      return specializations;
    }
  }

}