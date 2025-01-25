import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

class CustomerModel {
  String userName;
  String name;
  String password;
  String email;
  String phone;
  String role = "Client";
  bool isActive = false;
  bool isVerified = false;
  String gender;
  String? deviceToken;
  String birthDate;
  DateTime? lastActive;

  CustomerModel(
      this.name, this.userName, this.password, this.email, this.phone, this.gender, this.birthDate);

  // Get the hashed device token
  Future<String> getDeviceToken() async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceId;

    if (await deviceInfo.deviceInfo is AndroidDeviceInfo) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id ?? "unknown";
    } else if (await deviceInfo.deviceInfo is IosDeviceInfo) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? "unknown";
    } else {
      deviceId = "Unknown Device";
    }

    var bytes = utf8.encode(deviceId);
    String token = sha256.convert(bytes).toString();
    return token;
  }
}


class customerServices {
  final String apiUrl = "http://192.168.1.4:3000/api/graphql";

  Future<String> addCustomer(CustomerModel customer) async {
    // Await device token retrieval
    String deviceToken = await customer.getDeviceToken();

    // Ensure gender is in the correct format based on the enum

    // Construct GraphQL mutation query
    final request = {
      'query': '''
            mutation ClientSignUp {
                clientSignUp(
                    createUserDto: {
                        birthDate: "${customer.birthDate}",
                        deviceToken: "$deviceToken",
                        email: "${customer.email}",
                        gender:${customer.gender},
                        name: "${customer.name}",
                        password: "${customer.password}",
                        phone: "${customer.phone}",
                        username: "${customer.userName}"
                    }
                ) {
                    username
                }
            }
        ''',
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request),
      );

      print("Response: ${response.body}"); // Debugging the response

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['errors'] != null) {
          return data['errors'][0]['message'];
        }
        return "User added successfully";
      } else {
        return jsonDecode(response.body)['errors'][0]['message'];

      }

    } catch (e) {
      print("Exception: $e");
      return e.toString();

    }
  }

  Future<String> verifyCustomer(String code , String email) async {
    final request = {
      'query':'''
          mutation VerifyUserForSignUp {
            verifyUserForSignUp(code: "${code}", email: "${email}") {
                token
           }
}
      '''
    };
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request),
      );

      print("Response: ${response.body}"); // Debugging the response

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['errors'] != null) {
          return data['errors'][0]['message'];
        }
        return "User verified successfully";
      } else {
        return jsonDecode(response.body)['errors'][0]['message'];

      }

    } catch (e) {
      print("Exception: $e");
      return e.toString();

    }
  }

  Future<String> resendCode(String email) async{
    final request = {
      'query': '''
          mutation ResendSignUpOtp {
              ResendSignUpOtp(email: "${email}")
          }
      '''
    };
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request),
      );

      print("Response: ${response.body}"); // Debugging the response

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['errors'] != null) {
          return data['errors'][0]['message'];
        }
        return "Code Resend successfully";
      } else {
        return jsonDecode(response.body)['errors'][0]['message'];

      }

    } catch (e) {
      print("Exception: $e");
      return e.toString();

    }
  }

}