import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/Models/postModel.dart';
import 'package:gp_frontend/ViewModels/postViewModel.dart';

class postProvider with ChangeNotifier {
  postViewModel postVM = postViewModel();
  List<postModel> posts = [];
  final TextEditingController description = TextEditingController();
  final TextEditingController title = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController duration = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  bool loading = false;


  getClientPosts() async {
    try {
      posts = await postVM.fetchClientPosts();
      print("in provider");
      print(posts);
      notifyListeners();
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }

  getAllPosts() async {
    try {
      loading = true;
      notifyListeners();
      posts = await postVM.fetchAllPosts();
      print("in provider");
      print(posts);
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
      print("Error fetching posts: $e");
    }
  }

  void increment(TextEditingController controller) {
    int value = int.tryParse(controller.text) ?? 0;
    controller.text = (value + 1).toString();
    notifyListeners();
  }

  void decrement(TextEditingController controller) {
    int value = int.tryParse(controller.text) ?? 0;
    if (value > 0) {
      controller.text = (value - 1).toString();
      notifyListeners();
    }
  }
  Future<void> addPost(postModel order, String specializationId, File? image)async{
    await postVM.addPost(order, specializationId, image);
  }

  void disposeControllers() {
    description.dispose();
    title.dispose();
    price.dispose();
    duration.dispose();
    quantity.dispose();
  }


  Future<void> deletePost(String postId) async{
    loading = true;
     notifyListeners();
     try{
       await postVM.deletePost(postId);
       loading = false;
       notifyListeners();
     }catch(e){
       loading = false;
       notifyListeners();
       print(e);
     }
  }Future<void> updatePost(postModel post) async{
    loading = true;
     notifyListeners();
     try{
       await postVM.updatePost(post);
       loading = false;
       notifyListeners();
     }catch(e){
       loading = false;
       notifyListeners();
       print(e);
     }
  }




}