import 'package:flutter/material.dart';

class AddFinalProduct extends StatefulWidget {
  static String id = "AddFinalProductScreen";
  final List<Map<String, dynamic>> variations;

  const AddFinalProduct({super.key , required this.variations});

  @override
  State<AddFinalProduct> createState() => _AddFinalProductState();
}

class _AddFinalProductState extends State<AddFinalProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
