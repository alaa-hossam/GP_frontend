import 'dart:convert';

import 'package:http/http.dart' as http;

import '../SqfliteCodes/Token.dart';

class voucherModel{
  String code, type, id;
  int amount;

  voucherModel({required this.code,required this.amount,required this.type,required this.id});
}

class voucherService{
  final String apiUrl =
      "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();

  Future<List<voucherModel>> getVouchers() async {
    List<voucherModel> vouchers = [];

    String query = '''
    query GetAllGiftCodes {
    getAllGiftCodes {
        amount
        code
        id
        codeType
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
      print("-----------------------------------");
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> allVouchers = data['data']['getAllGiftCodes'];
        for(var voucher in allVouchers){
          vouchers.add(voucherModel(id: voucher['id'] ,amount:  voucher['amount']
              ,type:  voucher['codeType'] , code: voucher['code']));
        }
        return vouchers;
      } else {
        print('Failed to load vouchers: ${response.statusCode}');
      }
      return vouchers;
    } catch (e) {
      print('Error fetching vouchers: $e');
      return vouchers;
    }
  }
  Future<voucherModel> getspecificVouchers(String code) async {

    String query = '''
    query GetGiftCode {
    getGiftCode(code:"$code") {
        code
        id
        amount
        codeType
    }
}
  ''';
    print(query);

    final request = {
      'query': query,
      'variables': {
        'code':code
      }
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
        final Map<String, dynamic> voucher = data['data']['getGiftCode'];

        print(voucher);
        return voucherModel(code: voucher['code'],
            amount: voucher['amount'], type: voucher['codeType'], id: voucher['id']);
      } else {
        print('Failed to load voucher: ${response.statusCode}');
      }
      return voucherModel(code: "code", amount: 0, type: "", id: "");
    } catch (e) {
      print('Error fetching vouchers: $e');
      return voucherModel(code: "code", amount: 0, type: "", id: "");
    }
  }


}