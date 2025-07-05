import 'dart:convert';
import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_frontend/Providers/ProductProvider.dart';
import 'package:gp_frontend/SqfliteCodes/Token.dart';
import 'package:gp_frontend/SqfliteCodes/wishList.dart';
import 'package:gp_frontend/widgets/AppBar.dart';
import 'package:gp_frontend/widgets/customizeWishProduct.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../Providers/CategoryProvider.dart';
import '../widgets/Dimensions.dart';
import '../widgets/customizeCategory.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class wishListView extends StatefulWidget {
  static String id = "wishListScreen";

  wishListView({super.key});

  @override
  State<wishListView> createState() => _wishListViewState();
}

class _wishListViewState extends State<wishListView> {
  wishList myWishList = wishList();
  int selectedIndex = 0;
  late productProvider wishProvider = productProvider();




  wishProducts() async{
    await wishProvider.getWishProducts();
    print("before provider");
    print(wishProvider.wishListProducts);
  }
  Future<void> shareWishlistAsPdf() async {
    final pdf = pw.Document();
    final wishlist = wishProvider.wishListProducts;

    final baseColor = PdfColors.deepPurple;
    final headerStyle = pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.blue400);
    final labelStyle = pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800);
    final valueStyle = pw.TextStyle(fontSize: 12, color: PdfColors.black);

    // 🔧 First build the list of widgets asynchronously
    List<pw.Widget> wishlistWidgets = [
      pw.Center(child: pw.Text('My Wishlist', style: headerStyle)),
      pw.SizedBox(height: 15),
    ];

    for (var product in wishlist) {
      final imageUrl = product['imageUrl'];
      final response = await http.get(Uri.parse(imageUrl));
      final image = pw.MemoryImage(response.bodyBytes);

      wishlistWidgets.add(
        pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 20),
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.blue400, width: 1.5),
            borderRadius: pw.BorderRadius.circular(10),
            color: PdfColors.grey100,

          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.ClipRRect(
                horizontalRadius: 8,
                verticalRadius: 8,
                child: pw.Image(image, width: 100, height: 100, fit: pw.BoxFit.cover),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(product['name'], style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 5),
                    _buildInfoRow('Category:', product['category']['name'], labelStyle, valueStyle),
                    _buildInfoRow('Price:', '${product['lowestCustomPrice']} EGP', labelStyle, valueStyle),
                    _buildInfoRow('Rating:', product['averageRating'].toString(), labelStyle, valueStyle),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(30),
        ),
        build: (context) => wishlistWidgets,
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/wishlist.pdf');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)], text: 'My Wishlist (PDF)');
  }

  pw.Widget _buildInfoRow(String label, String value, pw.TextStyle labelStyle, pw.TextStyle valueStyle) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.RichText(
        text: pw.TextSpan(
          children: [
            pw.TextSpan(text: label + ' ', style: labelStyle),
            pw.TextSpan(text: value, style: valueStyle),
          ],
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar:customAppbar("WishList" , leading: IconButton(
      //   icon:Icon(Icons.arrow_back_ios_new) , color: Colors.white,
      //   onPressed: (){Navigator.pop(context);}
      // )
      //   ,),

      appBar: customAppbar(
        "WishList",
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed:()async{
              shareWishlistAsPdf();},
          ),
        ],
      ),

      body: ListView(
        children: [
          Consumer<CategoryProvider>(
            builder: (context, categoryProvider, child) {
              if (categoryProvider.categories.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: SizeConfig.horizontalBlock,
                  height: 43 * SizeConfig.verticalBlock,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryProvider.categories.length,
                    itemBuilder: (context, index) {
                      bool isSelected = index == selectedIndex;
                      var category = categoryProvider.categories[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Row(
                          children: [
                            Customizecategory("${category.name}", isSelected),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          Consumer<productProvider>(
            builder: (context, productProvider, child) {
              print("inside the provider itself");
              return FutureBuilder<void>(
                future: wishProducts(),
                builder: (context, snapshot) {
                  print("inside caller");
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    print("try");
                    print(wishProvider.wishListProducts);
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: wishProvider.wishListProducts.length,
                      itemBuilder: (context, index) {
                        final product = wishProvider.wishListProducts[index];
                        return customizeWishProuct(
                          product['imageUrl'],
                          product['name'],
                          product['category']['name'],
                          product['lowestCustomPrice'].toDouble(),
                          product['averageRating'].toDouble(),
                          product['id']
                        );
                      },
                    );
                  }
                },
              );
            },
          ),
        ],
      ),

    );
  }
}