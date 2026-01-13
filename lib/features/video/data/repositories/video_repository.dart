
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/network/api_client.dart';
import '../models/video_model.dart';

class VideoRepository {
  final ApiClient _apiClient;
  
  static String get _apiKey => dotenv.env['GOOGLE_API_KEY'] ?? ''; 
  
  // YouTube pagination requires tokens, but our current architecture uses int page.
  // We'll store the next page token in memory for this simple implementation, 
  // or just fetch most popular without deep pagination for now.
  // Ideally, we'd refactor the ViewModel to handle string tokens.
  String? _nextPageToken;

  VideoRepository(this._apiClient);

  Future<List<VideoModel>> getVideos({int page = 1}) async {
    if (_apiKey.isEmpty) {
      debugPrint('GOOGLE_API_KEY is missing');
      return [];
    }
    
    // Reset token if page 1 (refresh)
    if (page == 1) {
      _nextPageToken = null;
    }

    try {
      // 1. Search for candidates using search.list with videoDuration=short
      // This is much likely to yield Shorts than the generic 'mostPopular' chart.
      final searchResponse = await _apiClient.dio.get(
        'https://www.googleapis.com/youtube/v3/search',
        queryParameters: {
          'part': 'id',
          'q': '#shorts', // Query for Shorts content
          'type': 'video',
          'videoDuration': 'short', // Videos < 4 mins
          'maxResults': 50,
          'regionCode': 'VN',
          'order': 'relevance', // or 'date', or 'viewCount'
          'key': _apiKey,
          if (_nextPageToken != null) 'pageToken': _nextPageToken,
        },
      );

      final searchData = searchResponse.data;
      if (searchData == null) return [];
      
      _nextPageToken = searchData['nextPageToken'];
      final searchItems = searchData['items'] as List?;
      
      if (searchItems == null || searchItems.isEmpty) {
        debugPrint('No videos found in search.');
        return [];
      }

      final videoIds = searchItems
          .map((item) => item['id'] != null ? item['id']['videoId'] as String? : null)
          .where((id) => id != null)
          .join(',');

      if (videoIds.isEmpty) return [];

      // 2. Fetch Details for these IDs to verify strict Shorts criteria
      final detailsResponse = await _apiClient.dio.get(
        'https://www.googleapis.com/youtube/v3/videos',
        queryParameters: {
          'part': 'snippet,contentDetails,statistics',
          'id': videoIds,
          'key': _apiKey,
        },
      );

      final detailsData = detailsResponse.data;
      if (detailsData != null && detailsData['items'] != null) {
        final shorts = <VideoModel>[];
        final items = detailsData['items'] as List;

        for (var item in items) {
           final contentDetails = item['contentDetails'];
           final snippet = item['snippet'];
           
           if (contentDetails == null || snippet == null) continue;
           
           // 1. Duration Check (Must be <= 60s for Shorts, allow 1s buffer)
           final durationStr = contentDetails['duration'] ?? '';
           final seconds = _parseDuration(durationStr);
           
           if (seconds > 61) continue; 
           
           // Aspect Ratio Check Removed:
           // The YouTube API often returns 16:9 thumbnails for Shorts (with black bars or cropped),
           // making ratio validation unreliable. We'll rely on the '#shorts' query and duration to filter.

           shorts.add(VideoModel.fromJson(item));
        }

        debugPrint('Found ${shorts.length} verified Shorts via Search out of ${items.length} candidates.');
        return shorts;
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching YouTube videos: $e');
      return [];
    }
  }
  
  int _parseDuration(String duration) {
    if (duration.isEmpty) return 0;
    // ISO 8601 Duration Regex: PT#H#M#S
    final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
    final match = regex.firstMatch(duration);
    
    if (match == null) return 0;
    
    final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
    final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
    final seconds = int.tryParse(match.group(3) ?? '0') ?? 0;
    
    return hours * 3600 + minutes * 60 + seconds;
  }


  /// Transforms a Channel ID (UC...) into its Shorts Playlist ID (UUSH...)
  String getShortsPlaylistId(String channelId) {
    if (channelId.startsWith('UC')) {
      return channelId.replaceFirst('UC', 'UUSH');
    }
    return channelId; // Fallback or invalid
  }

  /// Transforms a Channel ID (UC...) into its Popular Shorts Playlist ID (UUPS...)
  String getPopularShortsPlaylistId(String channelId) {
    if (channelId.startsWith('UC')) {
      return channelId.replaceFirst('UC', 'UUPS');
    }
    return channelId;
  }

  // Legacy/Mock removed
}
