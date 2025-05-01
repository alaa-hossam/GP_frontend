import 'package:flutter/cupertino.dart';
import 'package:gp_frontend/Models/postModel.dart';

class postViewModel  extends ChangeNotifier{
  final postService apiServices = postService();

  Future<List<postModel>> fetchPosts() async {
    return await apiServices.getPosts();
  }


}
