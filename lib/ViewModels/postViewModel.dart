import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/Models/postModel.dart';

class postViewModel extends ChangeNotifier {
  final postService apiServices = postService();

  Future<List<postModel>> fetchClientPosts() async {
    return await apiServices.getClientPosts();
  }

  Future<List<postModel>> fetchAllPosts() async {
    return await apiServices.getAllPosts();
  }

  Future<void> addPost(
      postModel order, String specializationId, File? image) async {
    await apiServices.addPost(order, specializationId, image);
  }

  Future<void> deletePost(String postId) async {
    await apiServices.deletePost(postId);
  }

  Future<void> updatePost(
     postModel post) async {
    await apiServices.updatePost(post);
  }
}
