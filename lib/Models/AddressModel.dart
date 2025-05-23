import 'dart:convert';
import 'package:http/http.dart' as http;
import '../SqfliteCodes/Token.dart';

class AddressModel{
  double? latitude, longitude;
  String AddressOwner,City,State, StreetName;
  String? BuildingNum, FloorNum, FlatNum,
      PostalCode, PhoneNumber;
  bool? isPrimary;

  AddressModel(

      this.AddressOwner,
      this.City,
      this.State,
      this.StreetName,
  {this.BuildingNum,
      this.FloorNum,
      this.FlatNum,
      this.PostalCode,
      this.PhoneNumber,
      this.isPrimary,
    this.latitude,
    this.longitude,
  });
}

class AddressService{
  String ApiUrl =
      "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();

  Future<List<AddressModel>> getAddresses()async{
    List<AddressModel> myAddresses = [];

    String id = await token.getUUID('SELECT UUID FROM TOKENS');
    String Query = '''
    query GetUserAddresses {
    getUserAddresses(userId:  "${id}") {
        addressOwner
        streetName
        state
        city
    }
}''';

    final request = {
      'query': Query,
      'variables': {
        'userId':  "${id}",
      },
    };

    try {
      final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');

      final response = await http.post(
        Uri.parse(ApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode(request),
      );
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> addresses = data['data']['getUserAddresses'];
        print(addresses);
        for(var address in addresses){
          myAddresses.add(AddressModel(address['addressOwner'], address['city'],
              address['state']?? "", address['streetName']));
        }
        print(myAddresses);
        return myAddresses;


        
      } else {
        throw Exception('Failed to load products: ${response.body}');
      }
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }

  }
  Future<String> addAddresses(AddressModel address) async {
    String id = await token.getUUID('SELECT UUID FROM TOKENS');
    String Query = '''
      mutation CreateUserAddress {
        createUserAddress(
          input: {
            addressOwner: "${address.AddressOwner}"
            buildingNumber: "${address.BuildingNum}"
            city: "${address.City}"
            flatNumber: "${address.FlatNum}"
            floorNumber: "${address.FloorNum}"
            isPrimary: ${address.isPrimary}
            postalCode: "${address.PostalCode}"
            streetName: "${address.StreetName}"
            userId: "$id"
            state: "${address.State}"
          }
        ) {
          id
        }
      }
    ''';

    final request = {
      'query': Query,
    };

    try {
      final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');

      final response = await http.post(
        Uri.parse(ApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode(request),
      );

      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String addressId = data['data']['createUserAddress']['id'];
        print("Created Address ID: $addressId");
        return addressId;
      } else {
        throw Exception('Failed to add address: ${response.body}');
      }
    } catch (e) {
      print("Error adding address: $e");
      rethrow;
    }
  }

}