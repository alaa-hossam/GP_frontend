import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/widgets/AppBar.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';

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
        child: Expanded(
          child: ListView.builder(
            itemCount: productsRaw.length,
            itemBuilder: (context, index) {
              final product = productsRaw[index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 10 * SizeConfig.verticalBlock),
                child: ListTile(
                  leading: Image.network(
                    product.imageURL ?? '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported),
                  ),
                  title: Text(
                    product.name ?? 'Unknown Product',
                    style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Price: ${product.price} LE"),
                      Text("Quantity: ${product.Quantity}"),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
