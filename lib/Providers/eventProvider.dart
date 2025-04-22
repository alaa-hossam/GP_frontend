import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/Models/eventModel.dart';
import 'package:gp_frontend/ViewModels/eventViewModel.dart';
import '../ViewModels/eventViewModel.dart';

class EventProvider extends ChangeNotifier {
  eventViewModel EVM = eventViewModel();
  List<eventModel> _events = [];
  List<eventModel> get events => _events;

  EventProvider() {
    print("Event Provider initialized");
  }

  Future<void> fetchEvents() async {
    print("Fetching events...");
    await EVM.fetchEvents();
    _events = EVM.events.map((event) => event).toList();
    print("Events fetched: $_events");
    notifyListeners(); // Notify listeners about the updated events
  }

  Future<String> addEvent({
    required String name,
    required String dayDate,
    required String reminderDate,
  }) async {
    return EVM.addEvent(
      name: name,
      dayDate: dayDate,
      reminderDate: reminderDate,
    );
  }
}