import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/video_model.dart';

class VideoService {
  static const String _baseUrl = 'https://interesnoitochka.ru/api/v1';

  Future<List<VideoModel>> fetchRecommendations({
    int offset = 0,
    int limit = 10,
    String category = 'shorts',
    String dateFilterType = 'created',
    String sortBy = 'date_created',
    String sortOrder = 'desc',
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/videos/recommendations?offset=$offset&limit=$limit&category=$category&date_filter_type=$dateFilterType&sort_by=$sortBy&sort_order=$sortOrder',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> items = data['items'];
        return items.map((json) => VideoModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load recommendations: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }

  String buildHlsUrl(int videoId) {
    return '$_baseUrl/videos/video/$videoId/hls/playlist.m3u8';
  }
}
