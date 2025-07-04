import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/customizeWishProduct.dart';

class SharedWishlistView extends StatefulWidget {
  final String binId;
  const SharedWishlistView({required this.binId, Key? key}) : super(key: key);

  @override
  State<SharedWishlistView> createState() => _SharedWishlistViewState();
}

class _SharedWishlistViewState extends State<SharedWishlistView> {
  List<dynamic> wishlist = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    final url = Uri.parse('https://api.jsonbin.io/v3/b/${widget.binId}/latest');
    final apiKey = 'YOUR_JSONBIN_API_KEY';

    final response = await http.get(url, headers: {
      'X-Master-Key': apiKey,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        wishlist = data['record']['wishlist'];
        isLoading = false;
      });
    } else {
      print("Failed to fetch wishlist: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shared Wishlist')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: wishlist.length,
        itemBuilder: (context, index) {
          final product = wishlist[index];
          return customizeWishProuct(
            product['imageUrl'],
            product['name'],
            product['category']['name'],
            product['lowestCustomPrice'].toDouble(),
            product['averageRating'].toDouble(),
            product['id'],
          );
        },
      ),
    );
  }
}
