import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:provider/provider.dart';
import '../Providers/CategoryProvider.dart';
import '../Providers/ProductProvider.dart';
import '../widgets/customProduct.dart';
import '../widgets/customizeCategory.dart';

class HistoryProducts extends StatefulWidget {
  static String id = "GiftRecommendationProductsScreen";
  const HistoryProducts({super.key});

  @override
  State<HistoryProducts> createState() => _HistoryProductsState();
}

class _HistoryProductsState extends State<HistoryProducts> {
  int selectedIndex = 0;
  bool isLoading = true; // New state variable for loading
  bool hasHistory = false; // New state variable to track if there's history
  late productProvider prodProvider;

  @override
  void initState() {
    super.initState();
    // Simulate a 5-second loading process
    prodProvider = Provider.of<productProvider>(context, listen: false);
    prodProvider.historyProducts.clear();
    prodProvider.fetchHistoryProducts();
    hasHistory = prodProvider.historyProducts.isNotEmpty;
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        isLoading = false; // Stop loading after 5 seconds
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 85 * SizeConfig.verticalBlock,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF223F4A),
                Color(0xFF5095B0),
              ],
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
          'History',
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 20 * SizeConfig.textRatio,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: Stack(
        children: [
          if (isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    "Loading...",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
            )
          else
            ListView(
              children: [
                Consumer<productProvider>(
                  builder: (context, productProvider, child) {
                    if (productProvider.historyProducts.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: productProvider.historyProducts.length,
                        itemBuilder: (context, index) {
                          var product = productProvider.historyProducts[index];
                          return customProduct(
                            product.imageURL,
                            product.name,
                            Category: product.category,
                            product.price,
                            product.rate,
                            product.id,
                            false,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}