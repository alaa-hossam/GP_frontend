import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import '../SqfliteCodes/Token.dart';

class eventModel {
  String _name, _id, _dayDate, _reminderDate;

  eventModel(this._id, this._name, this._dayDate, this._reminderDate);

  String get name => _name;
  String get id => _id;
  String get dayDate => _dayDate;
  String get reminderDate => _reminderDate;
}

class eventService {
  final String apiUrl =
      "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  Token token = Token();
  List<eventModel> events = [];

  Future<List<eventModel>> getAllEvents() async {
    print("Fetching events from API...");
    final userId = await Token().getUUID('SELECT UUID FROM TOKENS');

    final request = {
      'query': '''
        query GetUserEvents {
          getUserEvents(userId: "${userId}") {
            name
            id
            dayDate
            reminderDate
          }
        }
      ''',
    };

    try {
      final myToken = await Token().getToken('SELECT TOKEN FROM TOKENS');
      print("Token retrieved: $myToken");
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
        List<dynamic> evnts = data['data']['getUserEvents'];
        print(data);

        if (evnts.isEmpty) {
          throw Exception("No events found for this user.");
        }

        return evnts.map((event) {
          return eventModel(
            event['id'],
            event['name'],
            event['dayDate'],
            event['reminderDate'],
          );
        }).toList();
      } else {
        throw Exception('Failed to load events: ${response.body}');
      }
    } catch (e) {
      print("Error fetching events: $e");
      rethrow; // Re-throw the exception to be handled by the ViewModel
    }
  }

  Future<String> addEvent(eventModel event) async {
    print("added event from API...");
    final userId = await token.getUUID('SELECT UUID FROM TOKENS');

    final request = {
      'query': '''
      mutation CreateUserEvent {
    createUserEvent(
        input: {
         dayDate: "${event.dayDate}", 
         name: "${event.name}",
          reminderDate: "${event.reminderDate}", 
          userId: "${userId}" }
    ) {
        id
    }
}
  ''',
    };

    try {
      final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');
      print("Token retrieved: $myToken");
      final response;
      response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode(request),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        return("Event Added Successfully");
      } else {
        throw Exception('Failed to add event: ${response.body}');
      }
    } catch (e) {
      return("Error adding event: $e");
    }
  }

  Future<String> updateEvent(eventModel event) async {
    print("added event from API...");

    final request = {
      'query': '''
      mutation UpdateUserEvent {
    updateUserEvent(
        input: { dayDate: "${event.dayDate}", id: "${event.id}", name: "${event.name}", reminderDate: "${event.reminderDate}" }
    ) {
        id
    }
}
  ''',
    };

    try {
      final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');
      print("Token retrieved: $myToken");
      final response;
      response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode(request),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        return("Event Updated Successfully");
      } else {
        throw Exception('Failed to update event: ${response.body}');
      }
    } catch (e) {
      return("Error updating event: $e");
    }
  }

  Future<String> deleteEvent(String eventId) async {
    print("added event from API...");

    final request = {
      'query': '''
      mutation DeleteUserEvent {
    deleteUserEvent(eventId: "${eventId}")
}
  ''',
    };

    try {
      final myToken = await token.getToken('SELECT TOKEN FROM TOKENS');
      print("Token retrieved: $myToken");
      final response;
      response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode(request),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        return("Event Deleted Successfully");
      } else {
        throw Exception('Failed to delete event: ${response.body}');
      }
    } catch (e) {
      return("Error deleting event: $e");
    }
  }


}
