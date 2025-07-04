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

  // Future<void> shareWishlistAsPdf() async {
  //   final pdf = pw.Document();
  //
  //   final wishlist = wishProvider.wishListProducts;
  //
  //   for (var product in wishlist) {
  //     final imageUrl = product['imageUrl'];
  //     final response = await http.get(Uri.parse(imageUrl));
  //     final image = pw.MemoryImage(response.bodyBytes);
  //
  //     pdf.addPage(
  //       pw.Page(
  //         build: (pw.Context context) {
  //           return pw.Container(
  //             padding: const pw.EdgeInsets.all(10),
  //             child: pw.Row(
  //               crossAxisAlignment: pw.CrossAxisAlignment.start,
  //               children: [
  //                 pw.Container(
  //                   width: 100,
  //                   height: 100,
  //                   child: pw.Image(image, fit: pw.BoxFit.cover),
  //                 ),
  //                 pw.SizedBox(width: 10),
  //                 pw.Expanded(
  //                   child: pw.Column(
  //                     crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                     children: [
  //                       pw.Text(product['name'],
  //                           style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
  //                       pw.Text('Category: ${product['category']['name']}'),
  //                       pw.Text('Price: ${product['lowestCustomPrice']} EGP'),
  //                       pw.Text('Rating: ${product['averageRating']}'),
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             ),
  //           );
  //         },
  //       ),
  //     );
  //   }
  //
  //   // Save the PDF file
  //   final output = await getTemporaryDirectory();
  //   final file = File('${output.path}/wishlist.pdf');
  //   await file.writeAsBytes(await pdf.save());
  //
  //   // Share the PDF
  //   await Share.shareXFiles([XFile(file.path)], text: 'My Wishlist (PDF)');
  // }



  Future<String> createDynamicLink(String binId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://san3a.page.link',
      link: Uri.parse('https://san3a.com/wishlist/$binId'), // <== must be a real domain or handled in app
      androidParameters: AndroidParameters(
        packageName: 'com.yourcompany.yourapp',
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.yourcompany.yourapp',
        appStoreId: '123456789', // optional
      ),
    );

    final ShortDynamicLink shortLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    return shortLink.shortUrl.toString();
  }



  Future<void> uploadAndShareWishlist(String email) async {
    try {
      final ids = await wishList().getProductIdsByEmail(email);
      final products = wishProvider.wishListProducts
          .where((prod) => ids.contains(prod['id']))
          .toList();

      // Step 1: Upload the wishlist JSON to JSONBin
      final url = Uri.parse('https://api.jsonbin.io/v3/b');
      final apiKey = r'$2a$10$mA/MU1ktlqt4VqFHJNlwtOcnOoOq21QmXQJFRnMr0jTjbTEwzgp.S';

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-Master-Key': apiKey,
        },
        body: jsonEncode({
          'email': email,
          'wishlist': products,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final binId = data['metadata']['id'];

        // Step 2: Create a Firebase Dynamic Link to the wishlist
        final DynamicLinkParameters parameters = DynamicLinkParameters(
          uriPrefix: 'https://san3a.page.link',
          link: Uri.parse('https://placeholder.san3a.com/wishlist/$binId'),
          androidParameters: AndroidParameters(
            packageName: 'com.gpfrontend.app', // e.g., com.gpfrontend.app
            minimumVersion: 0,
          ),

        );

        final ShortDynamicLink shortLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
        final Uri shortUrl = shortLink.shortUrl;

        // Step 3: Share the link
        await Share.share('Check out my wishlist! $shortUrl');
      } else {
        print('Upload failed: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to upload wishlist")),
        );
      }
    } catch (e) {
      print("Upload error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
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
              Token token = Token();
              String email = await token.getEmail() ?? "";
              uploadAndShareWishlist(email);},
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