import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:gp_frontend/views/chatBot.dart';
import 'package:gp_frontend/views/sharewishlist.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'views/signUpView.dart';
import 'views/logInView.dart';
import 'views/forgetPasswordView.dart';
import 'views/Home.dart';
import 'views/browseProducts.dart';
import 'views/searchView.dart';
import 'views/wishListView.dart';
import 'views/compareView.dart';
import 'views/productDetails.dart';
import 'views/HandcrafterRequest.dart';
import 'views/cartView.dart';
import 'views/RecommendGiftView.dart';
import 'views/GiftRecommendationProducts.dart';
import 'views/joinBazar.dart';
import 'views/BazarVariations.dart';
import 'views/BazarProductsReview.dart';
import 'views/showBazar.dart';
import 'views/AddAdvertisement.dart';
import 'views/AdvertisementsPackages.dart';
import 'views/PaymentScreen.dart';
import 'views/checkOut.dart';
import 'views/chooseAddress.dart';
import 'views/addAddress.dart';
import 'views/confirmOrder.dart';
import 'views/historyView.dart';
import 'views/eventsView.dart';
import 'views/posts.dart';
import 'views/addPost.dart';
import 'views/voucherView.dart';
import 'views/showOrders.dart';
import 'views/addCrafterReel.dart';
import 'views/addOffer.dart';
import 'views/addProduct.dart';
import 'views/ChatView.dart';
import 'views/ChatDetails.dart';
import 'views/UpdatePost.dart';
import 'views/buyGiftCard.dart';

import 'Providers/AdvertisementProvider.dart';
import 'Providers/CategoryProvider.dart';
import 'Providers/ProductProvider.dart';
import 'Providers/detailsProvider.dart';
import 'Providers/cartProvider.dart';
import 'Providers/BackagesProvider.dart';
import 'Providers/BazarProvider.dart';
import 'Providers/AddressProvider.dart';
import 'Providers/eventProvider.dart';
import 'Providers/postProvider.dart';
import 'Providers/offerProvider.dart';
import 'Providers/voucherProvider.dart';
import 'Providers/SearchProvider.dart';
import 'ViewModels/messageViewModel.dart';

import 'SqfliteCodes/cart.dart';
import 'SqfliteCodes/wishList.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize local SQLite databases
  await wishList().db;
  await Cart().db;

  // Handle dynamic links
  FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData? dynamicLink) {
    final Uri? deepLink = dynamicLink?.link;

    if (deepLink != null && deepLink.pathSegments.contains('wishlist')) {
      final binId = deepLink.pathSegments.last;
      navigatorKey.currentState?.pushNamed('/sharedWishlist', arguments: binId);
    }
  }).onError((error) {
    print('Dynamic Link Failed: $error');
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdvertisementProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => productProvider()),
        ChangeNotifierProvider(create: (_) => detailsProvider()),
        ChangeNotifierProvider(create: (_) => cartProvider()),
        ChangeNotifierProvider(create: (_) => galleryImageProvider()),
        ChangeNotifierProvider(create: (_) => BackagesProvider()),
        ChangeNotifierProvider(create: (_) => BazarProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => postProvider()),
        ChangeNotifierProvider(create: (_) => offerProvider()),
        ChangeNotifierProvider(create: (_) => voucherProvider()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: DevicePreview(
        builder: (context) => MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,
          builder: DevicePreview.appBuilder,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: logIn.id,
          routes: {
            SignUp.id: (_) => SignUp(),
            logIn.id: (_) => logIn(),
            forgetPassword.id: (_) => forgetPassword(),
            Home.id: (_) => Home(),
            AIChat.id: (_) => AIChat(),
            browseProducts.id: (_) => browseProducts(),
            searchView.id: (_) => searchView(),
            wishListView.id: (_) => wishListView(),
            compareScreen.id: (_) => compareScreen(),
            productDetails.id: (_) => productDetails(),
            HandcrafterRequest.id: (_) => HandcrafterRequest(),
            cartScreen.id: (_) => cartScreen(),
            RecommendGift.id: (_) => RecommendGift(),
            GiftRecommendationProducts.id: (_) => GiftRecommendationProducts(),
            JoinBazar.id: (_) => JoinBazar(),
            BazarVariations.id: (_) => BazarVariations(),
            BazarReview.id: (_) => BazarReview(),
            showBazar.id: (_) => showBazar(),
            Addadvertisement.id: (_) => Addadvertisement(),
            Advertisementspackages.id: (_) => Advertisementspackages(),
            Paymentscreen.id: (_) => Paymentscreen(),
            checkOut.id: (_) => checkOut(),
            chooseAddress.id: (_) => chooseAddress(),
            addAddress.id: (_) => addAddress(),
            confirmOrder.id: (_) => confirmOrder(),
            HistoryProducts.id: (_) => HistoryProducts(),
            EventsView.id: (_) => EventsView(),
            posts.id: (_) => posts(),
            addPost.id: (_) => addPost(),
            voucherView.id: (_) => voucherView(),
            showOrders.id: (_) => showOrders(),
            AddCrafterReel.id: (_) => AddCrafterReel(),
            addOffer.id: (_) => addOffer(),
            AddProduct.id: (_) => AddProduct(),
            ChatView.id: (_) => ChatView(),
            ChatDetails.id: (_) => ChatDetails(),
            UpdatePost.id: (_) => UpdatePost(),
            giftCard.id: (_) => giftCard(),
            '/sharedWishlist': (context) {
              final binId = ModalRoute.of(context)!.settings.arguments as String;
              return SharedWishlistView(binId: binId);
            },
          },
        ),
      ),
    );
  }
}
