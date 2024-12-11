import 'package:flutter/material.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import '../views/Home.dart';
import '../views/ProfileView.dart';

class BottomBar extends StatefulWidget {
  final int selectedIndex;

  BottomBar({this.selectedIndex = 0});

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  late int selectedIndex;
   int? oldselectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      selectedItemColor: SizeConfig.iconColor,
      unselectedItemColor: SizeConfig.fontColor,
      iconSize: SizeConfig.textRatio * 24,
      onTap: (index){
        setState(() {
          oldselectedIndex = selectedIndex;
          selectedIndex = index;
        });
        if(selectedIndex != oldselectedIndex){
        Navigator.push(context, MaterialPageRoute(builder: (context) => _widgetOptions[selectedIndex]));
        }
        },
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: '',
        ),
      ],
    );
  }
}
