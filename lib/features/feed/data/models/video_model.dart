class VideoModel {
  final int videoId;
  final String title;
  final String previewImage;
  final String? postImage;
  final int channelId;
  final String channelName;
  final String channelAvatar;
  final int numbersViews;
  final int durationSec;
  final bool free;
  final bool vertical;
  final String seoUrl;
  final DateTime datePublication;
  final bool draft;
  final String? timeNotReg;
  final String? timeNotPay;
  final bool hasAccess;
  final String contentType;
  final double? latitude;
  final double? longitude;
  final String? locationText;
  final int playlistId;

  VideoModel({
    required this.videoId,
    required this.title,
    required this.previewImage,
    this.postImage,
    required this.channelId,
    required this.channelName,
    required this.channelAvatar,
    required this.numbersViews,
    required this.durationSec,
    required this.free,
    required this.vertical,
    required this.seoUrl,
    required this.datePublication,
    required this.draft,
    this.timeNotReg,
    this.timeNotPay,
    required this.hasAccess,
    required this.contentType,
    this.latitude,
    this.longitude,
    this.locationText,
    required this.playlistId,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic v) => v is int ? v : int.tryParse(v.toString()) ?? 0;

    double? toDouble(dynamic v) => v == null
        ? null
        : (v is num ? v.toDouble() : double.tryParse(v.toString()));

    return VideoModel(
      videoId: toInt(json['video_id']),
      title: json['title']?.toString() ?? '',
      previewImage: json['preview_image']?.toString() ?? '',
      postImage: json['post_image']?.toString(),
      channelId: toInt(json['channel_id']),
      channelName: json['channel_name']?.toString() ?? '',
      channelAvatar: json['channel_avatar']?.toString() ?? '',
      numbersViews: toInt(json['numbers_views']),
      durationSec: toInt(json['duration_sec']),
      free: json['free'] == true || json['free'] == 1,
      vertical: json['vertical'] == true || json['vertical'] == 1,
      seoUrl: json['seo_url']?.toString() ?? '',
      datePublication: DateTime.parse(json['date_publication']),
      draft: json['draft'] == true || json['draft'] == 1,
      timeNotReg: json['time_not_reg']?.toString(),
      timeNotPay: json['time_not_pay']?.toString(),
      hasAccess: json['has_access'] == true || json['has_access'] == 1,
      contentType: json['content_type']?.toString() ?? '',
      latitude: toDouble(json['latitude']),
      longitude: toDouble(json['longitude']),
      locationText: json['location_text']?.toString(),
      playlistId: toInt(json['playlist_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'video_id': videoId,
      'title': title,
      'preview_image': previewImage,
      'post_image': postImage,
      'channel_id': channelId,
      'channel_name': channelName,
      'channel_avatar': channelAvatar,
      'numbers_views': numbersViews,
      'duration_sec': durationSec,
      'free': free,
      'vertical': vertical,
      'seo_url': seoUrl,
      'date_publication': datePublication.toIso8601String(),
      'draft': draft,
      'time_not_reg': timeNotReg,
      'time_not_pay': timeNotPay,
      'has_access': hasAccess,
      'content_type': contentType,
      'latitude': latitude,
      'longitude': longitude,
      'location_text': locationText,
      'playlist_id': playlistId,
    };
  }
}
