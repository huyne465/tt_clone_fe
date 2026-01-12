import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/network/api_client.dart';
import '../models/video_model.dart';

class VideoRepository {
  final ApiClient _apiClient;
  
  // Reuse key from old repo
  static String get _apiKey => dotenv.env['PEXELS_API_KEY'] ?? ''; 

  VideoRepository(this._apiClient);

  Future<List<VideoModel>> getVideos({int page = 1}) async {
    if (_apiKey.isEmpty) {
      // If no key, fallback to mock to prevent crash
      return _getMockVideos();
    }

    try {
      final response = await _apiClient.dio.get(
        'https://api.pexels.com/videos/popular',
        queryParameters: {
          'page': page,
          'per_page': 5,
          'min_width': 720,
        },
        options: Options(
          headers: {
            'Authorization': _apiKey,
          },
        ),
      );

      // Use compute if needed, but for simple list it's fine here.
      // Keeping it simple for now, but respecting the structure.
      final data = response.data;
      if (data != null && data['videos'] != null) {
        return (data['videos'] as List)
            .map((e) => VideoModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      // Log error (use a proper logger in production)
      debugPrint('Error fetching videos: $e');
      // If network fails (e.g. no internet), assume empty or error in UI
      // Or fallback to mock
      return _getMockVideos();
    }
  }

  List<VideoModel> _getMockVideos() {
    return [
      VideoModel(
        id: '1',
        url: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        title: 'Flying Bee',
        likes: 1240,
        username: '@nature_lover',
        caption: 'Flying Bee',
      ),
       VideoModel(
        id: '2',
        url: 'https://assets.mixkit.co/videos/preview/mixkit-taking-photos-from-different-angles-of-a-model-34421-large.mp4',
        title: 'Photoshoot',
        likes: 3500,
        username: '@model_life',
        caption: 'Photoshoot',
      ),
    ];
  }
}
