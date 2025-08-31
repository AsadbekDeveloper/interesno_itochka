import 'package:equatable/equatable.dart';
import '../../data/models/video_model.dart';

abstract class VideoFeedState extends Equatable {
  const VideoFeedState();

  @override
  List<Object> get props => [];
}

class VideoFeedInitial extends VideoFeedState {
  const VideoFeedInitial();
}

class VideoFeedLoading extends VideoFeedState {
  const VideoFeedLoading();
}

class VideoFeedLoaded extends VideoFeedState {
  final List<VideoModel> videos;

  const VideoFeedLoaded({required this.videos});

  @override
  List<Object> get props => [videos];
}

class VideoFeedError extends VideoFeedState {
  final String message;

  const VideoFeedError({required this.message});

  @override
  List<Object> get props => [message];
}
