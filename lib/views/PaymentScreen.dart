import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/orderModel.dart';
import 'package:gp_frontend/Providers/orderProvider.dart';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:gp_frontend/ViewModels/giftCardViewModel.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import '../CommomnFunctions/ProfileData.dart';
import '../External Services/PaymentAPI.dart';
import '../ViewModels/AdvertisementsViewModel.dart';
import '../widgets/Dimensions.dart';
import 'ProfileView.dart';

class Paymentscreen extends StatefulWidget {
  static String id = "Paymentscreen";

  @override
  State<Paymentscreen> createState() => _PaymentscreenState();
}

class _PaymentscreenState extends State<Paymentscreen> {
  late WebViewController _controller;
  bool isLoading = true;
  late double price;
  late String offerId, addressId, type, giftCode, AdvertisementURL, Package,email , message;
  File? AdvertisementImage;
  List<Map<String, dynamic>> products = [];
  bool _hasInitialized = false;
  bool _paymentStarted = false;
  bool bazar = false;

  orderProvider myOrderProvider = orderProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      final args =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

      type = args['type'];
      price = args['price'] ?? 0;
      addressId = args['addressId'] ?? "";

      if (type == "offer") {
        offerId = args['offerId'] ?? "";
      } else if (type == "ready" || type == "custom") {
        products = args['products'];
        giftCode = args['giftCode'] ?? "";
        bazar = args['bazar'];
      }else if (type == "advertisement" ) {
        AdvertisementImage = args['advertisementImage'];
        AdvertisementURL = args['AdvertisementURL'] ?? "";
        Package = args['package'];
      } else if (type == "GiftCard" ) {
        email = args['mail'];
        message = args['message'] ;
      }

      _hasInitialized = true;
      initPayment(); // ✅ Called only once, safely
    }
  }

  Future<void> _offerPost(String transactionId) async {
    Token token = Token();
    String id = await token.getUUID()??"";

    await myOrderProvider.createPostOrder(orderModel(
      addressId: addressId,
      offerId: offerId,
      transactionId: transactionId,
      userId: id,
    ));
  }

  Future<void> _advertisement(String transactionId) async {
    AdvertisementsViewModel AdsVM = AdvertisementsViewModel();

print(transactionId);
    await AdsVM.addAdvertisement(
        AdvertisementImage, AdvertisementURL, Package, transactionId);
  }

  Future<void> _giftCard(String transactionId) async {
    giftCardViewModel cardVM = giftCardViewModel();

    print(transactionId);
    await cardVM.buyGiftCard(email, price, message, transactionId);


  }

  Future<void> _readyOrder(String transactionId) async {
    Token token = Token();
    String id = await token.getUUID() ?? "";

    await myOrderProvider.createReadyOrder(
        orderModel(
          addressId: addressId,
          transactionId: transactionId,
          userId: id,
          products: products,
        ),
        giftCode,
        bazar);
  }

  Future<void> _customOrder(String transactionId) async {
    Token token = Token();
    String id = await token.getUUID()??"";

    await myOrderProvider.createCustomOrder(
        orderModel(
          addressId: addressId,
          transactionId: transactionId,
          userId: id,
          products: products,
        ),
        giftCode,
        bazar);
  }

  void _handlePaymentSuccess(String transactionId) {
    debugPrint("✅ Payment Successful! Transaction ID: $transactionId");

    if (type == "offer") {
      _offerPost(transactionId);
    } else if (type == "ready") {
      _readyOrder(transactionId);
    } else if (type == "custom") {
      _customOrder(transactionId);
    } else if (type == "advertisement" ){
      _advertisement(transactionId);
    }else if (type == "GiftCard" ){
      _giftCard(transactionId);
    }

    Navigator.pushReplacementNamed(context, '/PaymentResult', arguments: {
      'status': 'success',
      'transaction_id': transactionId,
    });
  }

  void _handlePaymentFailure() {
    print("❌ Payment Failed!");
    Navigator.pushReplacementNamed(
      context,
      '/PaymentResult',
      arguments: {'status': 'failed'},
    );
  }

  Future<void> initPayment() async {
    print(products);
    if (_paymentStarted) return;
    _paymentStarted = true;

    try {
      final token = await paymentService.authenticate();
      final orderId = await paymentService.createOrder(token, price * 100);
      final paymentKey =
      await paymentService.generatePaymentKey(token, price * 100, orderId);
      final url = paymentService.getIframeUrl(paymentKey);
      bool _paymentCompleted = false;


      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              if (_paymentCompleted) return; // prevent multiple triggers

              if (url.contains("success=true")) {
                _paymentCompleted = true;

                final Uri uri = Uri.parse(url);
                final String? txId = uri.queryParameters['id'];

                if (txId != null && txId.isNotEmpty) {
                  _handlePaymentSuccess(txId);
                } else {
                  print("⚠️ Transaction ID not found, using 'unknown'");
                  _handlePaymentSuccess("unknown");
                }
              } else if (url.contains("fail") || url.contains("cancel")) {
                _paymentCompleted = true;
                _handlePaymentFailure();
              }
            },
            onNavigationRequest: (request) {
              print("🌐 Navigating to: ${request.url}");
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(url));

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("❌ Payment init failed: $e");
      _handlePaymentFailure();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 85 * SizeConfig.verticalBlock,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF223F4A), Color(0xFF5095B0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: SizeConfig.textRatio * 15,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Payment',
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 20 * SizeConfig.textRatio,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
            onPressed: () {
              loadProfileByRole(
                context: context,
                onCustomerLoaded: (customer) {
                  print("Customer loaded: ${customer.name}");
                },
                onCrafterLoaded: (crafter) {
                  print("Crafter loaded: ${crafter.name}");
                },
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: _controller),
    );
  }
}
