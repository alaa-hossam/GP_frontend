import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../External Services/PaymentAPI.dart';
import '../Models/ProductModel.dart';
import '../widgets/Dimensions.dart';
import 'ProfileView.dart';

class Paymentscreen extends StatefulWidget {
  static String id = "Paymentscreen";
  const Paymentscreen({super.key});

  @override
  State<Paymentscreen> createState() => _PaymentscreenState();
}

class _PaymentscreenState extends State<Paymentscreen> {
  late WebViewController _controller;
  bool isLoading = true;
  late double price;

  bool _hasInitialized = false; // Prevent multiple calls

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is double) {
        price = args;
      } else {
        price = 0;
      }
      initPayment();
      _hasInitialized = true;
    }
  }

  Future<void> initPayment() async {
    try {

      final token = await paymentService.authenticate();
      final orderId = await paymentService.createOrder(token, price * 100);
      final paymentKey = await paymentService.generatePaymentKey(token, price * 100, orderId);
      final url = paymentService.getIframeUrl(paymentKey);

      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(url));

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // handle error, maybe show an alert
      print("Payment init failed: $e");
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
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: SizeConfig.textRatio * 15),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Payment',
          style: GoogleFonts.rubik(color: Colors.white, fontSize: 20 * SizeConfig.textRatio),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Profile.id);
            },
            icon: Icon(Icons.account_circle_outlined, color: Colors.white),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: _controller),
    );
  }
}
