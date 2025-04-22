import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/Models/eventModel.dart';

class eventViewModel  extends ChangeNotifier{
  final eventService eventSer = eventService();
  List<eventModel> _events = [];
  List<eventModel> get events => _events;

  Future<void> fetchEvents() async {
    try {
      print("Fetching events from API...");
      _events = await eventSer.getAllEvents();
      print("events fetched successfully: $_events");
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching events in VM: $e");
      notifyListeners();
    }
  }

  Future<String> addEvent({required name,required dayDate,required reminderDate})async{
    print("============================================================================================ add in vm");
    print(name);
    print(dayDate);
    print(reminderDate);
    eventModel event = eventModel("", name, dayDate, reminderDate);
    return eventSer.addEvent(event);
  }
  Future<String> updateEvent({required id,required name,required dayDate,required reminderDate})async{
    print("============================================================================================ update in vm");
    print(name);
    print(dayDate);
    print(reminderDate);
    eventModel event = eventModel(id, name, dayDate, reminderDate);
    return eventSer.updateEvent(event);
  }
  Future<String> deleteEvent({required eventId})async{
    print("============================================================================================ delete in vm");
    return eventSer.deleteEvent(eventId);
  }

}
