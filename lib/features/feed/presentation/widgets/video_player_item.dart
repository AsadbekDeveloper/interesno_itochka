import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../data/models/video_model.dart';
import '../../data/services/video_service.dart';
import '../pages/full_screen_player_page.dart';

class VideoPlayerItem extends StatefulWidget {
  final VideoModel video;
  final bool isCurrentPage;

  const VideoPlayerItem({
    super.key,
    required this.video,
    required this.isCurrentPage,
  });

  @override
  VideoPlayerItemState createState() => VideoPlayerItemState();
}

class VideoPlayerItemState extends State<VideoPlayerItem> {
  bool _showVideo = false;
  final GlobalKey<VideoPlayerWidgetState> _playerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.isCurrentPage) {
      _startAutoplayTimer();
    }
  }

  @override
  void didUpdateWidget(covariant VideoPlayerItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCurrentPage && !oldWidget.isCurrentPage) {
      _startAutoplayTimer();
    } else if (!widget.isCurrentPage && oldWidget.isCurrentPage) {
      setState(() {
        _showVideo = false;
      });
    }
  }

  void _startAutoplayTimer() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && widget.isCurrentPage) {
        setState(() {
          _showVideo = true;
        });
      }
    });
  }

  void _navigateToFullScreenPlayer(BuildContext context) async {
    if (_showVideo) {
      _playerKey.currentState?.pause();
    }
    await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            FullScreenPlayerPage(video: widget.video),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.ease;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return ScaleTransition(scale: animation.drive(tween), child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
    if (mounted && _showVideo) {
      _playerKey.currentState?.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToFullScreenPlayer(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            VideoPreview(video: widget.video),
            if (_showVideo)
              VideoPlayerWidget(key: _playerKey, video: widget.video),
            _VideoMetadataOverlay(video: widget.video),
          ],
        ),
      ),
    );
  }
}

class VideoPreview extends StatelessWidget {
  final VideoModel video;

  const VideoPreview({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      video.previewImage,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) =>
          const Center(child: Icon(Icons.error, color: Colors.red, size: 50)),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final VideoModel video;

  const VideoPlayerWidget({super.key, required this.video});

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  final VideoService _videoService = VideoService();

  void play() {
    _videoPlayerController?.play();
  }

  void pause() {
    _videoPlayerController?.pause();
  }

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() async {
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
        showControls: false,
        autoPlay: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );
      _videoPlayerController!.setVolume(0.0);
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing video player: $e');
      setState(() {
        _isInitialized = false;
      });
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
    if (_isInitialized &&
        _chewieController != null &&
        _videoPlayerController!.value.isInitialized) {
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _videoPlayerController!.value.size.width,
            height: _videoPlayerController!.value.size.height,
            child: Chewie(controller: _chewieController!),
          ),
        ),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }
}

class _VideoMetadataOverlay extends StatelessWidget {
  final VideoModel video;

  const _VideoMetadataOverlay({required this.video});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            video.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(video.channelAvatar),
                radius: 16,
              ),
              const SizedBox(width: 8),
              Text(
                video.channelName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.visibility, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                '${video.numbersViews} views',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.timer, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                '${video.durationSec ~/ 60}:${(video.durationSec % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
