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

class AddCrafterReel extends StatefulWidget {
  static String id = "AddCrafterReel";
  const AddCrafterReel({super.key});

  @override
  State<AddCrafterReel> createState() => _AddCrafterReelState();
}

class _AddCrafterReelState extends State<AddCrafterReel> {
  VideoPlayerController? _controller;
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

    _galleryVideos = await _selectedAlbum!.getAssetListRange(
      start: 0,
      end: 100,
    );
    setState(() {});
  }

  Future<File?> pickVideo({bool fromCamera = false}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
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

  Future<String?> _getVideoDuration(AssetEntity asset) async {
    final duration = await asset.duration;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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
            // Camera Upload
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
                        _controller = VideoPlayerController.file(file)
                          ..initialize().then((_) => setState(() {}));
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

            // Album Header
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
                          _loadVideos().then((_) => setState(() => _isLoading = false));
                        },
                      );
                    },
                  ),
                ),
              ),

            SizedBox(height: 10 * SizeConfig.verticalBlock),

            // Gallery Videos
            Expanded(
              child: _permissionDenied
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, size: 60, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      "Permission to access videos was denied.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16 * SizeConfig.textRatio,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        final PermissionState ps = await PhotoManager.requestPermissionExtend();
                        if (!mounted) return;

                        if (ps == PermissionState.authorized || ps == PermissionState.limited) {
                          setState(() {
                            _permissionDenied = false;
                          });
                          await _loadAlbums();
                          await _loadVideos();
                        } else if (ps == PermissionState.denied) {
                          // Just denied, user can try again
                          setState(() {
                            _permissionDenied = true;
                          });
                        } else if (ps == PermissionState.notDetermined) {
                          // Still undetermined, will retry
                          _requestPermissionAndLoad();
                        } else {
                          // Permanently denied
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Permission Required"),
                              content: const Text(
                                  "You have permanently denied access to media. Please enable it from app settings."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    PhotoManager.openSetting(); // 🔧 Open app settings
                                  },
                                  child: const Text("Open Settings"),
                                ),
                              ],
                            ),
                          );
                        }

                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: const Text("Retry"),
                    ),

                    TextButton(
                      onPressed: () => PhotoManager.openSetting(),
                      child: Text("Open Settings"),
                    ),
                  ],
                ),
              )
                  : _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _galleryVideos.isEmpty
                  ? const Center(child: Text("No videos found"))
                  : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      final thumbnail = snapshot.data ??
                          Container(color: Colors.grey);

                      return FutureBuilder(
                        future: _getVideoDuration(_galleryVideos[index]),
                        builder: (context, durationSnapshot) {
                          return GestureDetector(
                            onTap: () async {
                              final file = await _galleryVideos[index].file;
                              if (file == null) return;

                              _controller?.dispose();
                              _controller = VideoPlayerController.file(file)
                                ..initialize().then((_) => setState(() {}));
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
                                if (durationSnapshot.hasData)
                                  Positioned(
                                    bottom: 5,
                                    right: 5,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Text(
                                        durationSnapshot.data!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10 * SizeConfig.textRatio,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),

            // Selected Video Preview
            if (_controller != null && _controller!.value.isInitialized)
              Container(
                height: 150 * SizeConfig.verticalBlock,
                margin:
                EdgeInsets.only(top: 10 * SizeConfig.verticalBlock),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8 * SizeConfig.horizontalBlock,
                          vertical: 4 * SizeConfig.verticalBlock,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_controller!.value.duration.inMinutes}:${(_controller!.value.duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12 * SizeConfig.textRatio,
                          ),
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

extension on int {
  get inMinutes => null;
  get inSeconds => null;
}
