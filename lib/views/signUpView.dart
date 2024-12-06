import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/widgets/customizeTextFormField.dart';

class signUp extends StatelessWidget {
  static String id = "SignUpScreen";
  const signUp({super.key});

  @override
  Widget build(BuildContext context) {
    final _FullName = TextEditingController();
    final _phoneNumber = TextEditingController();
    final _email = TextEditingController();
    final _password = TextEditingController();

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
        body: ListView(
          children: [
            Column(
              children: [
                myTextFormField(controller: _FullName, hintName: "Full Name", icon: Icons.account_circle)
              ],
            )
          ],
        ),
      )
    );
  }
}
