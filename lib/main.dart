import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/Models/ProductModel.dart';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:gp_frontend/views/Home.dart';
import 'package:gp_frontend/views/ProfileView.dart';
import 'package:gp_frontend/views/SearchView.dart';
import 'package:gp_frontend/views/browseProducts.dart';
import 'package:gp_frontend/views/chatBot.dart';
import 'package:gp_frontend/views/compareView.dart';
import 'package:gp_frontend/views/forgetPasswordView.dart';
import 'package:gp_frontend/views/logInView.dart';
import 'package:gp_frontend/views/productDetails.dart';
import 'package:gp_frontend/views/productReviews.dart';
import 'package:gp_frontend/views/wishListView.dart';
import 'package:gp_frontend/widgets/BottomBar.dart';
import 'package:provider/provider.dart';
import 'Providers/CategoryProvider.dart';
import 'Providers/ProductProvider.dart';
import 'SqfliteCodes/wishList.dart';
import 'firebase_options.dart';
import 'views/signUpView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'fireBaseNotification.dart';

void main() async{
  // wishList w = wishList();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
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
        searchView.id:(BuildContext context) => searchView(),
        wishListView.id:(BuildContext context) => wishListView(),
        compareScreen.id:(BuildContext context) => compareScreen(),
        productDetails.id:(BuildContext context) => productDetails(),
        Productreviews.id:(BuildContext context) => Productreviews(),
      },
    );
  }
}
