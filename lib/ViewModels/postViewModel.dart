import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/Models/postModel.dart';
import 'package:image_picker/image_picker.dart';

class postViewModel  extends ChangeNotifier{
  final postService apiServices = postService();

  Future<List<postModel>> fetchClientPosts() async {
    return await apiServices.getClientPosts();
  }

  Future<List<postModel>> fetchAllPosts() async {
    return await apiServices.getAllPosts();
  }

  Future<void> addPost(postModel order, String specializationId, File? image) async{
     await apiServices.addPost(order, specializationId, image);
  }



}
