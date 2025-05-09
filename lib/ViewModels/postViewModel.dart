import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/Models/postModel.dart';
import 'package:image_picker/image_picker.dart';

class postViewModel  extends ChangeNotifier{
  final postService apiServices = postService();

  Future<List<postModel>> fetchPosts() async {
    return await apiServices.getPosts();
  }
  Future<void> addPost(postModel order, String specializationId, File? image) async{
     await apiServices.addPost(order, specializationId, image);
  }



}
