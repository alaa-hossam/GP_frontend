import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/Models/eventModel.dart';
import 'package:gp_frontend/ViewModels/eventViewModel.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:provider/provider.dart';

import '../Providers/eventProvider.dart';
import '../views/addEvent.dart';

class CustomizeEvent extends StatefulWidget {
  final eventModel event;
  const CustomizeEvent(this.event);

  @override
  State<CustomizeEvent> createState() => _CustomizeEventState();
}

class _CustomizeEventState extends State<CustomizeEvent> {
  int _daysDifference = 0; // To store the calculated difference in days
  late EventProvider eventProvider;
eventViewModel EVM = eventViewModel();

  @override
  void initState() {
    super.initState();
    _calculateDaysDifference(); // Calculate the difference when the widget initializes
  }

  // Function to calculate the difference in days
  void _calculateDaysDifference() {
    try {
      DateTime dayDateTime = DateTime.parse(widget.event.dayDate);
      DateTime reminderDateTime = DateTime.parse(widget.event.reminderDate);
      _daysDifference = dayDateTime.difference(reminderDateTime).inDays.abs();
    } catch (e) {
      print("Error parsing dates: $e");
      _daysDifference = 0; // Default value if there's an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15.0 * SizeConfig.horizontalBlock,
        vertical: 15 * SizeConfig.verticalBlock,
      ),
      child: Container(
        height: 100 * SizeConfig.verticalBlock,
        width: 361 * SizeConfig.horizontalBlock,
        decoration: BoxDecoration(
          color: Color(0x50E9E9E9),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color with opacity
              blurRadius: 1, // Spread of the shadow
              offset: Offset(0, 3), // Offset of the shadow (x, y)
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20 * SizeConfig.horizontalBlock,
            vertical: 10 * SizeConfig.verticalBlock,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Event Details Column
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.event.name,
                      style: TextStyle(
                        fontSize: 20 * SizeConfig.textRatio,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5 * SizeConfig.verticalBlock),
                    Text(
                      "Day Date: ${widget.event.dayDate}",
                      style: TextStyle(
                        fontSize: 10 * SizeConfig.textRatio,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 5 * SizeConfig.verticalBlock),
                    Text(
                      "Days Remaining: $_daysDifference",
                      style: TextStyle(
                        fontSize: 10 * SizeConfig.textRatio,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              // Icons for Edit and Delete
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit_outlined, size: 20, color: SizeConfig.iconColor),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => addEvent(1, event: widget.event),));
                      print("Edit button pressed for event: ${widget.event.name}");
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, size: 20, color: SizeConfig.iconColor),
                    onPressed: () async {
                      try {
                        await EVM.deleteEvent(eventId: widget.event.id);
                        // Notify the EventProvider to refresh the events list
                        final eventProvider = Provider.of<EventProvider>(context, listen: false);
                        await eventProvider.fetchEvents(); // Refresh the events list
                        // Optionally show a success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Event deleted successfully')),
                        );
                      } catch (e) {
                        print("Error deleting event: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to delete event')),
                        );
                      }
                    },
                  ),                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}