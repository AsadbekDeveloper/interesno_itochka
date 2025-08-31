import 'dart:ui';
import 'package:flutter/cupertino.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<VideoFeedBloc>().add(const FetchVideoRecommendations());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(children: [_VideoFeedView(), _BottomNavBar()]),
    );
  }
}

class _VideoFeedView extends StatefulWidget {
  const _VideoFeedView();

  @override
  State<_VideoFeedView> createState() => _VideoFeedViewState();
}

class _VideoFeedViewState extends State<_VideoFeedView> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
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
    return BlocBuilder<VideoFeedBloc, VideoFeedState>(
      builder: (context, state) {
        if (state is VideoFeedInitial || state is VideoFeedLoading) {
          return const Center(child: CupertinoActivityIndicator());
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
              final isCurrent = index == _currentPage;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: VideoPlayerItem(
                  video: videos[index],
                  isCurrentPage: isCurrent,
                ),
              );
            },
          );
        }
        return const Center(child: Text('Unknown state'));
      },
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withAlpha(50),
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _BottomNavBarItem(icon: CupertinoIcons.house_fill),
                  SizedBox(width: 16),
                  _BottomNavBarItem(icon: CupertinoIcons.search),
                  SizedBox(width: 16),
                  _BottomNavBarItem(icon: CupertinoIcons.add_circled),
                  SizedBox(width: 16),
                  _BottomNavBarItem(icon: CupertinoIcons.chat_bubble_2),
                  SizedBox(width: 16),
                  _BottomNavBarItem(icon: CupertinoIcons.person),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavBarItem extends StatelessWidget {
  const _BottomNavBarItem({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: Colors.white, size: 28.0);
  }
}
