import 'package:flutter/material.dart';
import 'package:gp_frontend/Models/indecatorModel.dart';

class IndecatorViewModel extends ChangeNotifier {
  final indecatorService indSer = indecatorService();
  List<indicatorModel> _allTags = [];
  List<indicatorModel> get allTags => _allTags;


  Future<void> fetchAllTags() async {
    try {
      _allTags = await indSer.getAllTags();
      print("in IVM");
      print(_allTags.length);
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching all Tags: $e");
      _allTags = [];
      notifyListeners();
    }
  }

}