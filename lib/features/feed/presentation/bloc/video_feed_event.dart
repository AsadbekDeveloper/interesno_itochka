import 'package:equatable/equatable.dart';

abstract class VideoFeedEvent extends Equatable {
  const VideoFeedEvent();

  @override
  List<Object> get props => [];
}

class FetchVideoRecommendations extends VideoFeedEvent {
  const FetchVideoRecommendations();

  @override
  List<Object> get props => [];
}
