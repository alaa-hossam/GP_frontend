import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/eventModel.dart';
import 'package:gp_frontend/ViewModels/eventViewModel.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:gp_frontend/widgets/customizeTextFormField.dart';
import '../widgets/customizeButton.dart';
import 'eventsView.dart';

class addEvent extends StatefulWidget {
  static String id = "addEventScreen";
  final int addOrUpdate;
  final eventModel? event; // Use PascalCase for class names
  const addEvent(this.addOrUpdate,{this.event});

  @override
  State<addEvent> createState() => _AddEventState();
}

class _AddEventState extends State<addEvent> {
  late TextEditingController _name ;
  late TextEditingController _dayDate ;
  late TextEditingController _reminderDate ;
  eventViewModel EVM = eventViewModel();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.addOrUpdate != 0 ? widget.event?.name : '');
    _dayDate = TextEditingController(text: widget.addOrUpdate != 0 ? widget.event?.dayDate : '');
    _reminderDate = TextEditingController(text: widget.addOrUpdate != 0 ? widget.event?.reminderDate : '');
  }

  @override
  void dispose() {
    _name.dispose();
    _dayDate.dispose();
    _reminderDate.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, int source) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = pickedDate.toLocal().toString().split(' ')[0];
      setState(() {
        if (source == 0) {
          _dayDate.text = formattedDate;
        } else if (source == 1) {
          _reminderDate.text = formattedDate;
        }
      });
    }
  }

  Future<String> _addEvent() async {
    try {
      return await EVM.addEvent(
        name: _name.text,
        dayDate: _dayDate.text,
        reminderDate: _reminderDate.text,
      );
    } catch (e) {
      return e.toString();
    }
  }
  Future<String> _updateEvent() async {
    try {
      return await EVM.updateEvent(
        id: widget.event?.id,
        name: _name.text,
        dayDate: _dayDate.text,
        reminderDate: _reminderDate.text,
      );
    } catch (e) {
      return e.toString();
    }
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
        title: widget.addOrUpdate == 0 ? Text(
          'Add Reminder' ,
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 20 * SizeConfig.textRatio,
          ),
        ): Text(
          'Update Reminder',
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
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.0 * SizeConfig.horizontalBlock,
              vertical: 15 * SizeConfig.verticalBlock,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTextFormField(
                    labelText: 'Reminder Name',
                    controller: _name,
                    hintName: widget.addOrUpdate == 0
                        ? 'Enter reminder name'
                        : widget.event?.name ?? '',
                    width: 363 * SizeConfig.horizontalBlock,
                    height: 60 * SizeConfig.verticalBlock,
                    maxLines: 1,
                    hintStyle: TextStyle(
                      color: SizeConfig.fontColor,
                      fontSize: SizeConfig.textRatio * 14,
                      fontFamily: 'Roboto',
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.textRatio * 14,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 10 * SizeConfig.verticalBlock),
                  MyTextFormField(
                    labelText: 'Date',
                    controller: _dayDate,
                    hintName: widget.addOrUpdate == 0
                        ? 'Enter the date'
                        : widget.event?.dayDate ?? '',
                    suffixIcon: Icon(
                      Icons.date_range,
                      color: SizeConfig.iconColor,
                    ),
                    onClickFunction: (BuildContext context) =>
                        _selectDate(context, 0),
                    width: 363 * SizeConfig.horizontalBlock,
                    height: 60 * SizeConfig.verticalBlock,
                    maxLines: 1,
                    hintStyle: TextStyle(
                      color: SizeConfig.fontColor,
                      fontSize: SizeConfig.textRatio * 14,
                      fontFamily: 'Roboto',
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.textRatio * 14,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 10 * SizeConfig.verticalBlock),
                  MyTextFormField(
                    labelText: 'Remind Date',
                    controller: _reminderDate,
                    hintName: widget.addOrUpdate == 0
                        ? 'Enter reminder date'
                        : widget.event?.reminderDate ?? '',
                    suffixIcon: Icon(
                      Icons.date_range,
                      color: SizeConfig.iconColor,
                    ),
                    onClickFunction: (BuildContext context) =>
                        _selectDate(context, 1),
                    width: 363 * SizeConfig.horizontalBlock,
                    height: 60 * SizeConfig.verticalBlock,
                    maxLines: 1,
                    hintStyle: TextStyle(
                      color: SizeConfig.fontColor,
                      fontSize: SizeConfig.textRatio * 14,
                      fontFamily: 'Roboto',
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.textRatio * 14,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 100 * SizeConfig.verticalBlock),
                  Center(
                    child:widget.addOrUpdate == 0 ? customizeButton(
                      buttonName: 'Add',
                      buttonColor: Color(0xFF5095B0),
                      fontColor: const Color(0xFFF5F5F5),
                      width: 175 * SizeConfig.horizontalBlock,
                      height: 50 * SizeConfig.verticalBlock,
                      onClickButton: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        String response = await _addEvent();

                        setState(() {
                          _isLoading = false;
                        });

                        if (response == "Event Added Successfully") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Event Added Successfully!")),
                          );
                          Navigator.pushReplacementNamed(context, EventsView.id);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response)),
                          );
                        }
                      },
                    ): customizeButton(
                      buttonName: 'Update',
                      buttonColor: Color(0xFF5095B0),
                      fontColor: const Color(0xFFF5F5F5),
                      width: 175 * SizeConfig.horizontalBlock,
                      height: 50 * SizeConfig.verticalBlock,
                      onClickButton: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        String response = await _updateEvent();

                        setState(() {
                          _isLoading = false;
                        });

                        if (response == "Event Updated Successfully") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Event Updated Successfully!")),
                          );
                          Navigator.pushReplacementNamed(context, EventsView.id);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response)),
                          );
                        }
                      },
                    ),

                  )
                ],
              ),
            ),
          ),
          // Loading Indicator
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}