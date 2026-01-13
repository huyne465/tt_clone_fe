import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' hide Video;
import '../../features/video/data/models/video_model.dart';
import '../../view_models/video_viewmodel.dart';
import '../../utils/size_config.dart';

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
    
    try {
      String playUrl = widget.video.url;
      
      // Extract stream if it's YouTube
      if (playUrl.contains('youtube.com') || playUrl.contains('youtu.be')) {
        final yt = YoutubeExplode();
        try {
          debugPrint('Extracting stream for ${widget.video.id}...');
          final manifest = await yt.videos.streamsClient.getManifest(widget.video.id);
          // Get the best quality muxed stream (video + audio)
          // For shorts/vertical, sometimes separate streams are better, but muxed is safest for basic player.
          final streamInfo = manifest.muxed.withHighestBitrate();
          playUrl = streamInfo.url.toString();
          debugPrint('Stream URL extracted: $playUrl');
        } catch (e) {
          debugPrint('Error extracting YouTube stream: $e');
        } finally {
          yt.close();
        }
      }

      await _player.open(Media(playUrl));
      await _player.setPlaylistMode(PlaylistMode.single);
    } catch (e) {
      debugPrint('Error opening media: $e');
    }
    
    _player.stream.error.listen((event) {
       debugPrint('VideoPlayer Error: $event');
    });
    _player.stream.log.listen((event) {
       debugPrint('VideoPlayer Log: $event');
    });
    
    if (mounted) {
      setState(() {
        _initialized = true;
      });
    }

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
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_initialized)
            SizedBox(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
              child: Video(
                controller: _controller,
                fit: BoxFit.cover,
                 // Hardware decoding is automatic in media_kit default configuration usually,
                 // but we ensure scaling is optimal.
                 controls: NoVideoControls,
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          
          // Overlay Info (Title, User, Likes)
          Positioned(
            bottom: SizeConfig.scaleHeight(20),
            left: SizeConfig.scaleWidth(20),
            right: SizeConfig.scaleWidth(100), // Space for side buttons
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.video.username,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.scaleText(16),
                  ),
                ),
                SizedBox(height: SizeConfig.scaleHeight(8)),
                Text(
                  widget.video.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.scaleText(14),
                  ),
                ),
              ],
            ),
          ),
          
          // Side Action Buttons (Likes, etc)
           Positioned(
            bottom: SizeConfig.scaleHeight(20),
            right: SizeConfig.scaleWidth(10),
            child: Column(
              children: [
                Icon(Icons.favorite_border, size: SizeConfig.scaleIcon(24), color: Colors.white),
                Text('${widget.video.likes}', style: TextStyle(color: Colors.white, fontSize: SizeConfig.scaleText(12))),
                SizedBox(height: SizeConfig.scaleHeight(20)),
                Icon(Icons.chat_bubble_outline, size: SizeConfig.scaleIcon(24), color: Colors.white),
                Text('${widget.video.comments}', style: TextStyle(color: Colors.white, fontSize: SizeConfig.scaleText(12))),
                 SizedBox(height: SizeConfig.scaleHeight(20)),
                Icon(Icons.share_outlined, size: SizeConfig.scaleIcon(24), color: Colors.white),
                 Text('Share', style: TextStyle(color: Colors.white, fontSize: SizeConfig.scaleText(12))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
