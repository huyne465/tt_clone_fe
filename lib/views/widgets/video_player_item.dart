import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../../features/video/data/models/video_model.dart';
import '../../view_models/video_viewmodel.dart';

class VideoPlayerItem extends ConsumerStatefulWidget {
  final VideoModel video;
  final int index;

  const VideoPlayerItem({
    super.key,
    required this.video,
    required this.index,
  });

  @override
  ConsumerState<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends ConsumerState<VideoPlayerItem> {
  late final Player _player;
  late final VideoController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    // Configure player for performance
    /// native player.
    _player = Player(
      configuration: const PlayerConfiguration(
        bufferSize: 32 * 1024 * 1024, // 32MB buffer
      ),
    );

    // Attempt to disable hardware decoding securely
    try {
      // ignore: avoid_dynamic_calls
      (_player.platform as dynamic)?.setProperty('hwdec', 'no');
      // Disable cache to avoid permission errors on emulator
      (_player.platform as dynamic)?.setProperty('cache', 'no');
    } catch (e) {
      debugPrint('Could not set player properties: $e');
    }

    _controller = VideoController(_player);

    debugPrint('Playing video: ${widget.video.url}');
    
    await _player.open(Media(widget.video.url));
    await _player.setPlaylistMode(PlaylistMode.single);
    
    _player.stream.error.listen((event) {
       debugPrint('VideoPlayer Error: $event');
    });
    _player.stream.log.listen((event) {
       debugPrint('VideoPlayer Log: $event');
    });
    
    setState(() {
      _initialized = true;
    });

    // Initial check to play if already visible
    _checkPlayStatus();
  }

  void _checkPlayStatus() {
    if (!mounted || !_initialized) return;

    final currentIndex = ref.read(videoViewModelProvider).currentIndex;
    if (currentIndex == widget.index) {
       _player.play();
    } else {
       _player.pause();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to index changes to pause/play via ViewModel
    ref.listen(videoViewModelProvider.select((s) => s.currentIndex), (prev, next) {
      if (next == widget.index) {
        _player.play();
      } else {
        _player.pause();
      }
    });

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_initialized)
            Video(
              controller: _controller,
              fit: BoxFit.cover,
               // Hardware decoding is automatic in media_kit default configuration usually,
               // but we ensure scaling is optimal.
               controls: NoVideoControls,
            )
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          
          // Overlay Info (Title, User, Likes)
          Positioned(
            bottom: 20,
            left: 20,
            right: 100, // Space for side buttons
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.video.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.video.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Side Action Buttons (Likes, etc)
           Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                const Icon(Icons.favorite, size: 35, color: Colors.white),
                Text('${widget.video.likes}', style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 20),
                const Icon(Icons.comment, size: 35, color: Colors.white),
                const Text('404', style: TextStyle(color: Colors.white)),
                 const SizedBox(height: 20),
                const Icon(Icons.share, size: 35, color: Colors.white),
                 const Text('Share', style: TextStyle(color: Colors.white)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
