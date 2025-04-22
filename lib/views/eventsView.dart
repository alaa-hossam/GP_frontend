import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/views/addEvent.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:gp_frontend/widgets/customizeEvent.dart';
import 'package:provider/provider.dart';
import '../Providers/eventProvider.dart';
import '../widgets/BottomBar.dart';

class EventsView extends StatefulWidget {
  static String id = "EventViewScreen";
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  late EventProvider eventProvider;
  bool isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      eventProvider = Provider.of<EventProvider>(context, listen: false);
      try {
        await eventProvider.fetchEvents(); // Fetch events
        setState(() {
          isLoading = false; // Stop loading after fetch is complete
        });
      } catch (e) {
        print("Error during initialization: $e");
        setState(() {
          isLoading = false; // Ensure loading stops even if an error occurs
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 80 * SizeConfig.verticalBlock,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF223F4A),
                Color(0xFF5095B0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: SizeConfig.textRatio * 15,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Upcoming Reminders',
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 20 * SizeConfig.textRatio,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: Stack(
        children: [isLoading
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                "Loading events...",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
        )
            : Consumer<EventProvider>(
          builder: (context, eventProvider, child) {
            if (eventProvider.events.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   'assets/images/no events.jpeg', // Replace with your image path
                    //   width: SizeConfig.verticalBlock * 100,
                    //   height: SizeConfig.verticalBlock * 100,
                    // ),
                    // SizedBox(height: 20),
                    Text(
                      "No Reminder",
                      style: TextStyle(
                        fontSize: 24 * SizeConfig.textRatio,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "You have no upcoming Reminders",
                      style: TextStyle(
                        fontSize: 16 * SizeConfig.textRatio,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: eventProvider.events.length,
                itemBuilder: (context, index) {
                  final event = eventProvider.events[index];
                  return CustomizeEvent(
                    event,
                  );
                },
              );
            }
          },
        ),
          Positioned(
            bottom: 0,
            right: 5,
            child: Padding(
              padding: EdgeInsets.only(right: 15 * SizeConfig.horizontalBlock , bottom: 5 * SizeConfig.verticalBlock),
              child: CircleAvatar(
                backgroundColor: SizeConfig.iconColor,
                radius: SizeConfig.horizontalBlock * 24,
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: SizeConfig.textRatio * 25,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => addEvent(0),));
                  },
                ),
              ),
            ),
          ),
        ]
      ),
      bottomNavigationBar: BottomBar(selectedIndex: 0, isVisible: true),
    );
  }
}