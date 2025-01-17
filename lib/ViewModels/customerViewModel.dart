import 'dart:convert';
import 'package:gp_frontend/Models/CustomerModel.dart';
import 'package:http/http.dart' as http;

class customerViewModel {
  final String apiUrl = "http://192.168.1.4:3000/api/graphql";
  customerServices customerProcesses = customerServices();

  Future<String> addUser({required birthDate,required email,required gender,required name,
    required password,required phone,required username})async{

    CustomerModel customer = CustomerModel(name, username, password, email, phone, gender, birthDate);
    return customerProcesses.addCustomer(customer);
  }

  Future fetchUser(String id) async {
    final request = {
      'query': '''
        query {
          user(id: "$id") {
            birthDate
            createdAt
            email
            gender
            id
            isActive
            username
          }
        }
      '''
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  verifyCustomer(String code , String email){
    customerProcesses.verifyCustomer(code, email);
  }
}
