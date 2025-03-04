import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/views/Home.dart';
import 'package:gp_frontend/views/ProfileView.dart';
import 'package:gp_frontend/views/browseProducts.dart';
import 'package:gp_frontend/views/chatBot.dart';
import 'package:gp_frontend/views/forgetPasswordView.dart';
import 'package:gp_frontend/views/logInView.dart';
import 'package:gp_frontend/widgets/BottomBar.dart';
import 'package:provider/provider.dart';
import 'Providers/CategoryProvider.dart';
import 'views/signUpView.dart';

void main() async{

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => imageProvider()),
          ChangeNotifierProvider(create: (_) => CategoryProvider()),
          ChangeNotifierProvider(create: (_) => buttonProvider()),
          ChangeNotifierProvider(create: (_) => productProvider()),
        ],
        child: DevicePreview(
          builder: (context) => MyApp(),
        ),
        // child: MyApp(),

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
        Home.id:(BuildContext context) => Home(),
        Profile.id:(BuildContext context) => Profile(),
        AIChat.id:(BuildContext context) => AIChat(),
        browseProducts.id:(BuildContext context) => browseProducts(),
      },
    );
  }
}
