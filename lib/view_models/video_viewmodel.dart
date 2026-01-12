import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/video/data/repositories/video_repository.dart';
import 'video_state.dart';

// Since the user asked for view_models structure, we'll redefine the provider here
// or import the repository provider. Let's import the one we already made or move it.
// For now, I'll assume usage of the existing repository provider.
import '../features/video/providers/video_providers.dart';

class VideoViewModel extends StateNotifier<VideoState> {
  final VideoRepository _repository;
  int _page = 1;

  VideoViewModel(this._repository) : super(const VideoState()) {
    loadVideos();
  }

  Future<void> loadVideos() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final newVideos = await _repository.getVideos(page: _page);
      
      if (newVideos.isNotEmpty) {
        state = state.copyWith(
          videos: [...state.videos, ...newVideos],
          isLoading: false,
        );
        _page++;
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void onIndexChanged(int index) {
    state = state.copyWith(currentIndex: index);
    // Load more when near end
    if (index >= state.videos.length - 2) {
      loadVideos();
    }
  }
}

final videoViewModelProvider = StateNotifierProvider<VideoViewModel, VideoState>((ref) {
  final repository = ref.watch(videoRepositoryProvider);
  return VideoViewModel(repository);
});
