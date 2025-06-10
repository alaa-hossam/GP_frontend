import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../widgets/Dimensions.dart';
import '../widgets/customizeButton.dart';
import 'package:path_provider/path_provider.dart';
import 'ShareCrafterReel.dart'; // Ensure this import is correct

class AddCrafterReel extends StatefulWidget {
  static String id = "AddCrafterReel";
  const AddCrafterReel({super.key});

  @override
  State<AddCrafterReel> createState() => _AddCrafterReelState();
}

class _AddCrafterReelState extends State<AddCrafterReel> {
  VideoPlayerController? _controller;
  File? selectedVideoFile; // ✅ This will be passed to the next screen

  List<AssetEntity> _galleryVideos = [];
  bool _showAlbums = false;
  List<AssetPathEntity> _albums = [];
  AssetPathEntity? _selectedAlbum;
  bool _isLoading = true;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _requestPermissionAndLoad();
  }

  @override
  void dispose() {
    _controller?.dispose();
    PhotoManager.clearFileCache();
    super.dispose();
  }

  Future<void> _requestPermissionAndLoad() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!mounted) return;

    if (ps == PermissionState.authorized || ps == PermissionState.limited) {
      _permissionDenied = false;
      await _loadAlbums();
      await _loadVideos();
    } else {
      _permissionDenied = true;
    }

    setState(() => _isLoading = false);
  }

  Future<void> _loadAlbums() async {
    _albums = await PhotoManager.getAssetPathList(
      type: RequestType.video,
      onlyAll: false,
    );
    _selectedAlbum = _albums.first;
    setState(() {});
  }

  Future<void> _loadVideos() async {
    if (_selectedAlbum == null) return;

    final allVideos = await _selectedAlbum!.getAssetListRange(
      start: 0,
      end: 100,
    );

    _galleryVideos = allVideos.where((video) => video.duration <= 30).toList();
    setState(() {});
  }

  Future<File?> pickVideo({bool fromCamera = false}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final controller = VideoPlayerController.file(file);
      await controller.initialize();

      final duration = controller.value.duration;
      await controller.dispose();

      if (duration.inSeconds <= 30) {
        return file;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Video must be 30 seconds or less")),
        );
        return null;
      }
    }

    return null;
  }

  Future<Widget> _getThumbnail(AssetEntity asset) async {
    final file = await asset.file;
    if (file == null) return const Icon(Icons.error);

    final tempDir = await getTemporaryDirectory();
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: file.path,
      thumbnailPath: tempDir.path,
      imageFormat: ImageFormat.JPEG,
      quality: 25,
    );

    if (thumbnailPath == null) return const Icon(Icons.error);

    return Image.file(
      File(thumbnailPath),
      fit: BoxFit.cover,
    );
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
      body: Padding(
        padding: EdgeInsets.all(20 * SizeConfig.verticalBlock),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: SizeConfig.horizontalBlock * 110,
                height: SizeConfig.verticalBlock * 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: SizeConfig.iconColor),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        size: 40 * SizeConfig.textRatio,
                        color: SizeConfig.iconColor,
                      ),
                      onPressed: () async {
                        final file = await pickVideo(fromCamera: true);
                        if (file == null) return;

                        _controller?.dispose();
                        _controller = VideoPlayerController.file(file);
                        await _controller!.initialize();
                        selectedVideoFile = file; // ✅ Store selected video
                        setState(() {});
                      },
                    ),
                    Text(
                      'Camera',
                      style: TextStyle(
                        fontSize: 10 * SizeConfig.textRatio,
                        color: SizeConfig.iconColor,
                      ),
                    )
                  ],
                ),
              ),
            ),

            SizedBox(height: 20 * SizeConfig.verticalBlock),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      _selectedAlbum?.name ?? 'Recents',
                      style: TextStyle(
                        fontSize: 16 * SizeConfig.textRatio,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_drop_down),
                      onPressed: () {
                        setState(() => _showAlbums = !_showAlbums);
                      },
                    ),
                  ],
                ),
                customizeButton(
                  buttonName: "Next",
                  buttonColor: SizeConfig.iconColor,
                  fontColor: Colors.white,
                  sufixIcon: Icons.arrow_forward,
                  textSize: 18 * SizeConfig.textRatio,
                  width: 90 * SizeConfig.horizontalBlock,
                  height: 40 * SizeConfig.verticalBlock,
                  rad: 5,
                  onClickButton: () {
                    if (selectedVideoFile != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ShareCrafterReel(videoFile: selectedVideoFile!),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please select a video first")),
                      );
                    }
                  },
                ),
              ],
            ),

            if (_showAlbums)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    itemCount: _albums.length,
                    itemBuilder: (context, index) {
                      final album = _albums[index];
                      return ListTile(
                        title: Text(album.name),
                        onTap: () {
                          setState(() {
                            _selectedAlbum = album;
                            _showAlbums = false;
                            _isLoading = true;
                          });
                          _loadVideos()
                              .then((_) => setState(() => _isLoading = false));
                        },
                      );
                    },
                  ),
                ),
              ),

            SizedBox(height: 10 * SizeConfig.verticalBlock),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _galleryVideos.isEmpty
                  ? const Center(child: Text("No videos found"))
                  : GridView.builder(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 0.7,
                ),
                itemCount: _galleryVideos.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: _getThumbnail(_galleryVideos[index]),
                    builder: (context, snapshot) {
                      final thumbnail =
                          snapshot.data ?? Container(color: Colors.grey);
                      return GestureDetector(
                        onTap: () async {
                          final file =
                          await _galleryVideos[index].file;
                          if (file == null) return;

                          final tempController =
                          VideoPlayerController.file(file);
                          await tempController.initialize();
                          final duration = tempController.value.duration;
                          await tempController.dispose();

                          if (duration.inSeconds <= 30) {
                            _controller?.dispose();
                            _controller =
                                VideoPlayerController.file(file);
                            await _controller!.initialize();
                            selectedVideoFile = file; // ✅ Store file
                            setState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Only videos 30 seconds or shorter are allowed."),
                              ),
                            );
                          }
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: thumbnail,
                            ),
                            Center(
                              child: Icon(
                                Icons.play_circle_fill,
                                color: Colors.white.withOpacity(0.8),
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            if (_controller != null && _controller!.value.isInitialized)
              Container(
                height: 150 * SizeConfig.verticalBlock,
                margin: EdgeInsets.only(top: 10 * SizeConfig.verticalBlock),
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller!.dispose();
                            _controller = null;
                            selectedVideoFile = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

