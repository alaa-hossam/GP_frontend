import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/ViewModels/handcrafterViewModel.dart';
import 'package:gp_frontend/widgets/Dimensions.dart';
import 'package:video_player/video_player.dart';

import '../widgets/customizeButton.dart';
import '../widgets/customizeTextFormField.dart';

class ShareCrafterReel extends StatefulWidget {
  final File? videoFile;

  const ShareCrafterReel({super.key, required this.videoFile});

  @override
  State<ShareCrafterReel> createState() => _ShareCrafterReelState();
}

class _ShareCrafterReelState extends State<ShareCrafterReel> {
  late VideoPlayerController _controller;
  TextEditingController _caption = TextEditingController();
  bool _isLoading = false;
  handcrafterViewModel HVM = handcrafterViewModel();
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _caption.addListener(_updateCharacterCount); // Listen to text changes
  }

  void _updateCharacterCount() {
    setState(() {}); // Rebuild the UI to update the character counter
  }

  Future<void> _initializeVideo() async {
    if (widget.videoFile == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("No video selected"),
            content: const Text("Please select a video before continuing."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // Close dialog
                child: const Text("OK"),
              ),
            ],
          ),
        ).then((_) => Navigator.of(context).pop()); // Return to previous screen
      });
      return;
    }

    setState(() => _isInitializing = true);

    try {
      _controller = VideoPlayerController.file(widget.videoFile!)
        ..setLooping(true)
        ..initialize().then((_) {
          if (mounted) {
            setState(() => _isInitializing = false);
            _controller.play();
          }
        }).catchError((error) {
          if (mounted) {
            setState(() => _isInitializing = false);
            _showErrorDialog("Failed to load video");
          }
        });
    } catch (e) {
      if (mounted) {
        setState(() => _isInitializing = false);
        _showErrorDialog("Invalid video file");
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    ).then((_) => Navigator.of(context).pop());
  }

  @override
  void dispose() {
    _caption.removeListener(_updateCharacterCount); // Remove listener
    _caption.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<String> _saveData() async {
    if (_caption.text.isEmpty) {
      return "Please write a caption";
    }

    try {
      return await HVM.addHandcrafterReel(
          content: _caption.text, file: widget.videoFile);
    } catch (e) {
      return "An error occurred: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 85 * SizeConfig.verticalBlock,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF223F4A), Color(0xFF5095B0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: SizeConfig.textRatio * 15,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Reel',
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 20 * SizeConfig.textRatio,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20 * SizeConfig.verticalBlock),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 20 * SizeConfig.verticalBlock,
            children: [
              Center(
                child: Container(
                  width: 200 * SizeConfig.horizontalBlock,
                  height: 350 * SizeConfig.verticalBlock,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: SizeConfig.iconColor, width: 1),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _isInitializing
                          ? const CircularProgressIndicator()
                          : _controller.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                )
                              : const Text("Failed to load video"),
                      if (_controller.value.isInitialized)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                            padding:
                                EdgeInsets.all(10 * SizeConfig.horizontalBlock),
                            child: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 40 * SizeConfig.textRatio,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              MyTextFormField(
                controller: _caption,
                labelText: "Write a caption",
                width: 361 * SizeConfig.horizontalBlock,
                height: 50 * SizeConfig.verticalBlock,
                maxLength: 300,
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: SizeConfig.textRatio * 16,
                  fontFamily: 'Roboto',
                ),
                borderColor: SizeConfig.iconColor,
                borderwidth: 1,
                borderRadius: 5,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${300 - _caption.text.length} characters remaining",
                    style: TextStyle(
                      color: Color(0xFF3C3C3C).withOpacity(0.5),
                      fontSize: 16 * SizeConfig.textRatio,
                      fontFamily: "Roboto",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50 * SizeConfig.verticalBlock,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  customizeButton(
                    buttonName: "Cancel",
                    buttonColor: const Color(0xFFE9E9E9).withOpacity(0.5),
                    fontColor: SizeConfig.iconColor,
                    width: 173 * SizeConfig.horizontalBlock,
                    rad: 5,
                    onClickButton: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                  customizeButton(
                    buttonName: "Share",
                    buttonColor: SizeConfig.iconColor,
                    fontColor: Colors.white,
                    width: 173 * SizeConfig.horizontalBlock,
                    rad: 5,
                    // Add onClickButton logic here
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
