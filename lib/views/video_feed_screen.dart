import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';
import '../view_models/video_viewmodel.dart';
import 'widgets/video_player_item.dart';

class VideoFeedScreen extends ConsumerWidget {
  const VideoFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the ViewModel state
    final videoState = ref.watch(videoViewModelProvider);
    final viewModel = ref.read(videoViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (videoState.errorMessage != null)
            Center(
              child: Text(
                'Error: ${videoState.errorMessage}',
                style: const TextStyle(color: Colors.white),
              ),
            )
          else if (videoState.videos.isEmpty && videoState.isLoading)
             const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          else
            PreloadPageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: videoState.videos.length,
              preloadPagesCount: 2,
              controller: PreloadPageController(),
              onPageChanged: (index) {
                viewModel.onIndexChanged(index);
              },
              itemBuilder: (context, index) {
                return VideoPlayerItem(
                  key: ValueKey(videoState.videos[index].id),
                  video: videoState.videos[index],
                  index: index,
                );
              },
            ),
            
           if (videoState.isLoading && videoState.videos.isNotEmpty)
             const Positioned(
               bottom: 20,
               left: 0,
               right: 0,
               child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
             ),
        ],
      ),
    );
  }
}
