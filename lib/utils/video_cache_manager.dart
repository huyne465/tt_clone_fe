import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoCacheManager {
  static const key = 'libCachedVideo';
  
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 2), // Keep video for 2 days
      maxNrOfCacheObjects: 20,              // Keep max 20 videos
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}
