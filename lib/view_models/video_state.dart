import 'package:freezed_annotation/freezed_annotation.dart';
import '../features/video/data/models/video_model.dart';

part 'video_state.freezed.dart';

@freezed
sealed class VideoState with _$VideoState {
  const factory VideoState({
    @Default([]) List<VideoModel> videos,
    @Default(true) bool isLoading,
    @Default(0) int currentIndex,
    String? errorMessage,
  }) = _VideoState;
}
