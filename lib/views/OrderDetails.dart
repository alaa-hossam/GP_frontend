import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/widgets/AppBar.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:gp_frontend/widgets/ProductOrderDetails.dart';

class OrderDetailsScreen extends StatelessWidget {
  static String id = "OrderDetailsScreen";

  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final order = args['order'];
    List<dynamic> productsRaw;
    if (order['products'] is List) {
      productsRaw = order['products'];
    } else {
      productsRaw = [order['products']];
    }
    String shortId = order['id'].toString().split('-').first;


    return Scaffold(
      appBar: customAppbar("Order #${shortId}" , leading:  IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: SizeConfig.textRatio * 15),
        onPressed: () => Navigator.pop(context),
      ),),
      body: Padding(
        padding: EdgeInsets.all(12.0 * SizeConfig.horizontalBlock),
        child: ListView.builder(
          itemCount: productsRaw.length,
          itemBuilder: (context, index) {
            final product = productsRaw[index];
            return ProductOrderDetails(product: product);
          },
        ),
      ),
    );
  }
}
