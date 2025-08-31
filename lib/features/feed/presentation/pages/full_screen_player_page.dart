import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../data/models/video_model.dart';
import '../../data/repositories/video_repository.dart';

class FullScreenPlayerPage extends StatefulWidget {
  final VideoModel video;

  const FullScreenPlayerPage({super.key, required this.video});

  @override
  FullScreenPlayerPageState createState() => FullScreenPlayerPageState();
}

class FullScreenPlayerPageState extends State<FullScreenPlayerPage> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  final VideoRepository _videoService = VideoRepository();

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() async {
    final hlsUrl = _videoService.buildHlsUrl(widget.video.videoId);
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(hlsUrl),
    );

    try {
      await _videoPlayerController!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        looping: true,
        autoPlay: true,
        showOptions: false,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );
      _videoPlayerController!.setVolume(1.0);
      setState(() {});
    } catch (e) {
      debugPrint('Error initializing full screen video player: $e');
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child:
                  _chewieController != null &&
                      _chewieController!
                          .videoPlayerController
                          .value
                          .isInitialized
                  ? Chewie(controller: _chewieController!)
                  : const CircularProgressIndicator(),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
