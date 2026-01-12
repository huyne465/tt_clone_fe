import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../data/repositories/video_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final videoRepositoryProvider = Provider<VideoRepository>((ref) {
  return VideoRepository(ref.watch(apiClientProvider));
});
