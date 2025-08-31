import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/video_service.dart';
import '../../data/models/video_model.dart';
import 'video_feed_event.dart';
import 'video_feed_state.dart';

class VideoFeedBloc extends Bloc<VideoFeedEvent, VideoFeedState> {
  final VideoService _videoService;

  VideoFeedBloc({required VideoService videoService})
    : _videoService = videoService,
      super(const VideoFeedInitial()) {
    on<FetchVideoRecommendations>(_onFetchVideoRecommendations);
  }

  Future<void> _onFetchVideoRecommendations(
    FetchVideoRecommendations event,
    Emitter<VideoFeedState> emit,
  ) async {
    emit(const VideoFeedLoading());
    try {
      final List<VideoModel> videos = await _videoService
          .fetchRecommendations();
      emit(VideoFeedLoaded(videos: videos));
    } catch (e) {
      emit(VideoFeedError(message: e.toString()));
    }
  }
}
