import 'package:flutter/material.dart';
import '../Models/handcrafterModel.dart';
import '../widgets/ReelWidget.dart';

class ReelsView extends StatefulWidget {
  final handcrafterModel handcrafter;

  const ReelsView({super.key, required this.handcrafter});

  @override
  State<ReelsView> createState() => _ReelsViewState();
}

class _ReelsViewState extends State<ReelsView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final posts = widget.handcrafter.posts ?? [];

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return ReelsWidget(
            videoUrl: post.fileURl,
            handCrafterName: widget.handcrafter.name ?? 'Unknown',
            description: post.content,
            profileUrl: widget.handcrafter.profileURL,
          );
        },
      ),
    );
  }
}
