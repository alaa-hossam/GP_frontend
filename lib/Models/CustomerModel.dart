import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import '../SqfliteCodes/Token.dart';
import '../fireBaseNotification.dart';

class CustomerModel {
  String? userName;
  String? name;
  String? password;
  String? email;
  String? phone;
  String? role = "Client";
  bool? isActive = false;
  bool? isVerified = false;
  String? gender;
  String? deviceToken;
  String? birthDate;
  DateTime? lastActive;
  String? profileImage;
  double? points;

  CustomerModel(
      {this.name,
      this.userName,
      this.password,
      this.email,
      this.phone,
      this.gender,
      this.birthDate,
      this.profileImage,
      this.points});

  // Get the hashed device token
  Future<String?> getDeviceToken() async {
    return NotificationFire().initNotification();
  }
}

class customerServices {
  final String apiUrl =
      "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";

  Future<String> addCustomer(CustomerModel customer) async {
    // Await device token retrieval
    String? deviceToken = await customer.getDeviceToken();

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

  Future<String> verifyCustomer(String code, String email) async {
    Token token = Token();

    print(code);
    print(email);
    final request = {
      'query': '''
          mutation VerifyUserForSignUp {
    verifyUserForSignUp(code: "$code", email: "$email") {
        token {
            expireAt
            token
        }
        user {
            id
        }
    }
}


      '''
    };
    print(request);
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
        final accessToken =
            data['data']['verifyUserForSignUp']['token']['token'];
        final String expireAt =
            data['data']['verifyUserForSignUp']['token']['expireAt'];
        final UUID = data['data']['verifyUserForSignUp']['user']['id'];
        String insertQuery = '''
                              INSERT INTO TOKENS (UUID, TOKEN, EXPIRED)
                              VALUES ("$UUID", "$accessToken", "$expireAt")
                             ''';
        String updateQuery = '''
                                UPDATE TOKENS
                                SET TOKEN = "$accessToken", 
                                 EXPIRED = "$expireAt"
                        
                       ''';

        if (await token.isTokensTableEmpty()) {
          await token.addToken(insertQuery);
        } else {
          await token.updateToken(updateQuery);
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

  Future<String> resendCode(String email) async {
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

  Future<String> logInCustomer(String email, String password) async {
    Token token = Token();
    String? deviceToken = "";
    try {
      deviceToken = await CustomerModel().getDeviceToken();
    } catch (e) {
      print("Error retrieving device token: $e");
    }
    final request = {
      'query': '''
          mutation Login {
    login(loginInput: { 
    deviceToken: "$deviceToken", 
    email: "${email}", 
    password: "${password}" }) {
        token {
            expireAt
            token
            createdAt
        }
        user {
            id
            role
            email
        }
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

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['errors'] != null) {
          return data['errors'][0]['message'];
        }
        final accessToken = data['data']['login']['token']['token'];
        final createdAt = data['data']['login']['token']['createdAt'];
        final expireAt = data['data']['login']['token']['expireAt'];
        final UUID = data['data']['login']['user']['id'];
        final Role = data['data']['login']['user']['role'];
        final email = data['data']['login']['user']['email'];
        print("+++++++++++++++++++++++++++++++++++$Role");
        String insertQuery = '''
                              INSERT INTO TOKENS (UUID, TOKEN, EXPIRED , ROLE , email)
                              VALUES ("$UUID", "$accessToken", "$expireAt" , "$Role" , "$email")
                             ''';
        String updateQuery = '''
                                UPDATE TOKENS
                                SET TOKEN = "$accessToken", 
                                 EXPIRED = "$expireAt",
                                 UUID = "$UUID",
                                 ROLE = "$Role",
                                 EMAIL = "$email"
                        
                       ''';

        if (await token.isTokensTableEmpty()) {
          await token.addToken(insertQuery);
        } else {
          await token.updateToken(updateQuery);
        }

        return "User Log In Successfully";
      } else {
        return jsonDecode(response.body)['errors'][0]['message'];
      }
    } catch (e) {
      print("Exception: $e");
      return e.toString();
    }
  }

  Future<String> forgetPassGetCode(String email) async {
    final request = {
      'query': '''
          mutation SendResetPasswordOtp {
              sendResetPasswordOtp(email: "${email}")
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
        return "Code Send Successfully";
      } else {
        return jsonDecode(response.body)['errors'][0]['message'];
      }
    } catch (e) {
      print("Exception: $e");
      return e.toString();
    }
  }

  Future<String> checkResetPassCode(String email, String code) async {
    print("Code: $code");
    print("Email: $email");

    final request = {
      'query': '''
      mutation CheckResetPasswordCode {
        checkResetPasswordCode(
          code: "$code", 
          email: "$email"
        )
      }
    '''
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request),
      );
      print("Response: ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['errors'] != null) {
          return data['errors'][0]['message'];
        }

        if (data['data'] != null &&
            data['data']['checkResetPasswordCode'] == true) {
          return "Code Verified Successfully";
        } else {
          return "Invalid Code";
        }
      } else {
        return jsonDecode(response.body)['errors'][0]['message'];
      }
    } catch (e) {
      print("Exception: $e");
      return e.toString();
    }
  }

  Future<String> ResetPass(
      String email, String newPass, String confirmPass) async {
    final request = {
      'query': '''
      mutation ResetPassword {
        resetPassword(
          confirmPassword: "$confirmPass",
          email: "$email", 
          newPassword: "$newPass"
        )
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

        if (data['data'] != null && data['data']['resetPassword'] == true) {
          return "Password Changed Successfully";
        } else {
          return "Failed to Reset Password. Please Try Again.";
        }
      } else {
        return jsonDecode(response.body)['errors'][0]['message'];
      }
    } catch (e) {
      print("Exception: $e");
      return e.toString();
    }
  }

  Future<CustomerModel?> getUser(String id) async {
    Token token = Token();
    CustomerModel? customer;
    String query = '''
    query User {
    user(id: "${id}") {
        clientProfile {
            imageUrl
            name
        }
    }
} 
    ''';
    final request = {
      'query': query,
      'variables': {
        'id': id,
      },
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

        // Access getProduct safely
        final getCustomer = data['data']['user']['clientProfile'];
        customer = CustomerModel(
            name: getCustomer['name'], profileImage: getCustomer['imageUrl']);
        return customer;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return customer;
    }
  }

  Future<CustomerModel?> getUserProfile() async {
    print("get user profile");
    Token token = Token();
    final userId = await token.getUUID('SELECT UUID FROM TOKENS');

    CustomerModel? customer;
    String query = '''
    query User {
    user(id: "${userId}") {
        email
        clientProfile {
            imageUrl
            name
            points
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

        // Access getProduct safely
        final getCustomer = data['data']['user'];
        customer = CustomerModel(
            name: getCustomer['clientProfile']['name'],
            profileImage: getCustomer['clientProfile']['imageUrl'],
            email: getCustomer['email'],
            points: getCustomer['clientProfile']['points'].toDouble()
        );
        return customer;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return customer;
    }
  }

  Future<String> getUserEmail() async {
    Token token = Token();
    final viewerId = await token.getUUID('SELECT UUID FROM TOKENS');

    String query = '''
    query User {
    user(id: "${viewerId}") {
        email
    }
}

    ''';
    final request = {
      'query': query,
      'variables': {
        'id': viewerId,
      },
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

        final email = data['data']['user']['email'];

        return email;
      }
      return 'error happen';
    } catch (e) {
      // print('Error fetching user: $e');
      return 'Error fetching user: $e';
    }
  }
}
