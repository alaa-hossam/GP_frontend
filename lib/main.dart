import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/Providers/BackagesProvider.dart';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:gp_frontend/views/AddAdvertisement.dart';
import 'package:gp_frontend/views/AdvertisementsPackages.dart';
import 'package:gp_frontend/views/BazarProductsReview.dart';
import 'package:gp_frontend/views/GiftRecommendationProducts.dart';
import 'package:gp_frontend/views/HandcrafterRequest.dart';
import 'package:gp_frontend/views/Home.dart';
import 'package:gp_frontend/views/PaymentScreen.dart';
import 'package:gp_frontend/views/MyHandcrafterProfile.dart';
import 'package:gp_frontend/views/ProfileView.dart';
import 'package:gp_frontend/views/RecommendGiftView.dart';
import 'package:gp_frontend/views/SearchView.dart';
import 'package:gp_frontend/views/addAddress.dart';
import 'package:gp_frontend/views/browseProducts.dart';
import 'package:gp_frontend/views/cartView.dart';
import 'package:gp_frontend/views/chatBot.dart';
import 'package:gp_frontend/views/checkOut.dart';
import 'package:gp_frontend/views/chooseAddress.dart';
import 'package:gp_frontend/views/compareView.dart';
import 'package:gp_frontend/views/confirmOrder.dart';
import 'package:gp_frontend/views/forgetPasswordView.dart';
import 'package:gp_frontend/views/joinBazar.dart';
import 'package:gp_frontend/views/logInView.dart';
import 'package:gp_frontend/views/productDetails.dart';
import 'package:gp_frontend/views/productReviews.dart';
import 'package:gp_frontend/views/showBazar.dart';
import 'package:gp_frontend/views/wishListView.dart';
import 'package:gp_frontend/widgets/BottomBar.dart';
import 'package:provider/provider.dart';
import 'Providers/AdvertisementProvider.dart';
import 'Providers/BazarProvider.dart';
import 'Providers/CategoryProvider.dart';
import 'Providers/ProductProvider.dart';
import 'Providers/cartProvider.dart';
import 'Providers/detailsProvider.dart';
import 'SqfliteCodes/cart.dart';
import 'SqfliteCodes/wishList.dart';
import 'firebase_options.dart';
import 'views/signUpView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'fireBaseNotification.dart';
import 'views/BazarVariations.dart';
import 'views/PaymentScreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize databases
  Token token = Token();
  wishList wish = wishList();
  Cart myCart = Cart();

  await token.db;
  await wish.db; // Initialize Wishlist database
  await myCart.db; // Initialize Cart database

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdvertisementProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => buttonProvider()),
        ChangeNotifierProvider(create: (_) => productProvider()),
        ChangeNotifierProvider(create: (_) => detailsProvider()),
        ChangeNotifierProvider(create: (_) => cartProvider()),
        ChangeNotifierProvider(create: (_) => galleryImageProvider()),
        ChangeNotifierProvider(create: (_) => BackagesProvider()),
        ChangeNotifierProvider(create: (_) => BazarProvider()),
      ],
      child: DevicePreview(
        builder: (context) => MyApp(),
      ),
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
        HandcrafterRequest.id:(BuildContext context) => HandcrafterRequest(),
        cartScreen.id:(BuildContext context) => cartScreen(),
        RecommendGift.id : (BuildContext context) => RecommendGift(),
        GiftRecommendationProducts.id : (BuildContext context) => GiftRecommendationProducts(),
        JoinBazar.id : (BuildContext context) => JoinBazar(),
        BazarVariations.id : (BuildContext context) => BazarVariations(),
        BazarReview.id : (BuildContext context) => BazarReview(),
        showBazar.id : (BuildContext context) => showBazar(),
        Addadvertisement.id : (BuildContext context) => Addadvertisement(),
        Advertisementspackages.id : (BuildContext context) => Advertisementspackages(),
        Paymentscreen.id : (BuildContext context) => Paymentscreen(),
        MyHandcrafterProfile.id : (BuildContext context) => MyHandcrafterProfile(),
        checkOut.id : (BuildContext context) => checkOut(),
        chooseAddress.id : (BuildContext context) => chooseAddress(),
        addAddress.id : (BuildContext context) => addAddress(),
        confirmOrder.id : (BuildContext context) => confirmOrder(),

      },
    );
  }
}
