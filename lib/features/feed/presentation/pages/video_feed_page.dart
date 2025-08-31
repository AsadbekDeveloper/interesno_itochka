import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/video_player_item.dart';
import '../bloc/video_feed_bloc.dart';
import '../bloc/video_feed_event.dart';
import '../bloc/video_feed_state.dart';

class VideoFeedPage extends StatefulWidget {
  const VideoFeedPage({super.key});

  @override
  VideoFeedPageState createState() => VideoFeedPageState();
}

class VideoFeedPageState extends State<VideoFeedPage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    context.read<VideoFeedBloc>().add(const FetchVideoRecommendations());
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VideoFeedBloc, VideoFeedState>(
        builder: (context, state) {
          if (state is VideoFeedInitial || state is VideoFeedLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VideoFeedError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is VideoFeedLoaded) {
            final videos = state.videos;
            if (videos.isEmpty) {
              return const Center(child: Text('No recommendations found.'));
            }
            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: VideoPlayerItem(
                    video: videos[index],
                    isCurrentPage: index == _currentPage,
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }
}
