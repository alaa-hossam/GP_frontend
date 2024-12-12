import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/views/Home.dart';
import 'package:gp_frontend/views/ProfileView.dart';
import 'package:gp_frontend/views/forgetPasswordView.dart';
import 'package:gp_frontend/views/logInView.dart';
import 'package:gp_frontend/views/resetPassword.dart';
import 'package:provider/provider.dart';
import 'views/signUpView.dart';
import 'views/GetOTP.dart';
import 'views/Home.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => imageProvider()),
          ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ],
        child: DevicePreview(
          builder: (context) => MyApp(),
        ),

  ));
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
      initialRoute: logIn.id,
      routes: {
        SignUp.id: (BuildContext context) => SignUp(),
        logIn.id: (BuildContext context) => logIn(),
        forgetPassword.id: (BuildContext context) => forgetPassword(),
        resetPassword.id: (BuildContext context) => resetPassword(),
        Getotp.id:(BuildContext context) => Getotp(),
        Home.id:(BuildContext context) => Home(),
        Profile.id:(BuildContext context) => Profile()

      },
    );
  }
}
