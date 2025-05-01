import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/Models/postModel.dart';
import 'package:gp_frontend/ViewModels/postViewModel.dart';
import '../Models/ProductModel.dart';
import '../ViewModels/productViewModel.dart';

class postProvider with ChangeNotifier {
  postViewModel postVM = postViewModel();
  List<postModel> posts = [];

  getPosts() async {
    try {
      posts = await postVM.fetchPosts();
      print("in provider");
      print(posts);
      notifyListeners();
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }


}