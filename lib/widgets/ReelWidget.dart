import 'package:flutter/material.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:video_player/video_player.dart';

class ReelsWidget extends StatefulWidget {
  final String videoUrl, handCrafterName, description;
  final String? profileUrl;

  const ReelsWidget({
    super.key,
    required this.videoUrl,
    required this.handCrafterName,
    required this.description,
    this.profileUrl,
  });

  @override
  State<ReelsWidget> createState() => _ReelsWidgetState();
}

class _ReelsWidgetState extends State<ReelsWidget> {
  late VideoPlayerController _controller;
  bool _showPlayButton = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _showPlayButton = true;
      } else {
        _controller.play();
        _showPlayButton = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        children: [
          // Video background
          _controller.value.isInitialized
              ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          )
              : const Center(child: CircularProgressIndicator()),

          // Center play button
          if (!_controller.value.isPlaying)
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 64,
                ),
              ),
            ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                _controller.pause();
                Navigator.pop(context);
              },
            ),
          ),

          // Info section
          Positioned(
            bottom: 20,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: SizeConfig.iconColor,
                      radius: SizeConfig.horizontalBlock * 20,
                      child: CircleAvatar(
                        radius: SizeConfig.horizontalBlock * 18,
                        backgroundColor: Colors.white,
                        child: widget.profileUrl != null
                            ? ClipOval(
                          child: Image.network(
                            widget.profileUrl!,
                            width: SizeConfig.horizontalBlock * 36,
                            height: SizeConfig.horizontalBlock * 36,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Icon(
                          Icons.person,
                          size: SizeConfig.horizontalBlock * 18,
                          color: SizeConfig.iconColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.handCrafterName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    widget.description,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
