import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/Models/orderModel.dart';
import 'package:gp_frontend/Providers/orderProvider.dart';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import '../External Services/PaymentAPI.dart';
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
  late String offerId, addressId , type;
  bool _hasInitialized = false;
  orderProvider myOrderProvider = orderProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      type = args['type'];
      if(type == "offer"){
        price = args['price'] ?? 0;
        offerId = args['offerId'] ?? "";
        addressId = args['addressId'] ?? "";
      }


      initPayment();
      _hasInitialized = true;
    }
  }

  Future<void> _offerPost(String transactionId) async {
    Token token = Token();
    String id = await token.getUUID('SELECT UUID FROM TOKENS');

    final success =await myOrderProvider.createPostOrder(orderModel(
        addressId: addressId,
        offerId: offerId,
        transactionId: transactionId,
        userId: id));
  }

  void _handlePaymentSuccess(String transactionId) {
    debugPrint("✅ Payment Successful! Transaction ID: $transactionId");

    if(type == "offer"){
      _offerPost(transactionId);

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
    try {
      final token = await paymentService.authenticate();
      final orderId = await paymentService.createOrder(token, price * 100);
      final paymentKey =
          await paymentService.generatePaymentKey(token, price * 100, orderId);
      final url = paymentService.getIframeUrl(paymentKey);

      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              if (url.contains("success=true")) {
                final Uri uri = Uri.parse(url);
                final String? txId = uri.queryParameters['id'];

                if (txId != null && txId.isNotEmpty) {
                  _handlePaymentSuccess(txId);
                } else {
                  print("! Transaction ID not found in success URL");
                  _handlePaymentSuccess("unknown");
                }
              } else if (url.contains("fail") || url.contains("cancel")) {
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
            icon:
                const Icon(Icons.account_circle_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, Profile.id);
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
