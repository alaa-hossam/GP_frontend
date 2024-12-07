import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/views/forgetPasswordView.dart';
import 'package:gp_frontend/views/logInView.dart';
import 'package:gp_frontend/views/resetPassword.dart';
import 'views/signUpView.dart';
import 'views/GetOTP.dart';

void main() {
  runApp(
    DevicePreview(
      builder: (context) => MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: SignUp.id,
      routes: {
        SignUp.id: (BuildContext context) => SignUp(),
        logIn.id: (BuildContext context) => logIn(),
        forgetPassword.id: (BuildContext context) => forgetPassword(),
        resetPassword.id: (BuildContext context) => resetPassword(),
        Getotp.id:(BuildContext context) => Getotp()
      },
    );
  }
}
