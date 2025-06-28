import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:gp_frontend/views/messageView.dart';
import 'package:gp_frontend/views/posts.dart';
import 'package:gp_frontend/views/showOrders.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:http/http.dart';
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
                icon: Icon(FontAwesomeIcons.android),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.checkroom),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
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

  int get selectedIndex => _selectedIndex;

  void updateIndex(BuildContext context, int index) async {
    _oldselected = _selectedIndex;
    _selectedIndex = index;

    if (_oldselected != _selectedIndex) {
      Widget screen;

      switch (index) {
        case 0:
          screen = Home();
          break;
        case 1:
          screen = AIChat();
          break;
        case 2:
          screen = posts();
          break;
        case 3:
          String id = await getId(); // 👈 Now you're awaiting correctly
          screen = ChatScreen(
            currentUserId: id,
            otherUserId: "bf6c1277-7f7f-41c2-993b-d5a4c3a48d1a",
          );
          break;
        default:
          screen = Home();
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => screen,
        ),
      );
    }

    notifyListeners();
  }

  Future<String> getId() async {
    Token token = Token();
    return await token.getUUID('SELECT UUID FROM TOKENS');
  }
}
