import 'package:flutter/material.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:provider/provider.dart';
import '../views/Home.dart';
import '../views/ProfileView.dart';
import '../views/chatBot.dart';

class BottomBar extends StatefulWidget {
  final int selectedIndex;
  final bool isVisible;


  BottomBar({this.selectedIndex = 0 , required this.isVisible} );

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }



  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Consumer<buttonProvider>(
      builder: (context, buttonProvider, child) {
        return Visibility(
          visible: widget.isVisible,
          child: BottomNavigationBar(

            currentIndex: buttonProvider.selectedIndex,
            selectedItemColor: SizeConfig.iconColor,
            unselectedItemColor: SizeConfig.fontColor,
            iconSize: SizeConfig.textRatio * 24,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (index) {
              buttonProvider.updateIndex(context,index);
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: '',
              ),
            ],
          ),
        );
      },
    );
  }
}


class buttonProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int? _oldselected;
  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    AIChat(),
    Profile(),
  ];
  int get selectedIndex => _selectedIndex;

  void updateIndex(BuildContext context,int index) {
    _oldselected = _selectedIndex;
    _selectedIndex = index;
    if(_oldselected != _selectedIndex) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _widgetOptions[index]),
      );
    }
    notifyListeners();
  }
}