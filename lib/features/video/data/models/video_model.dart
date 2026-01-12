class VideoModel {
  final String id;
  final String url;
  final String title;
  final int likes;
  final String username;
  final String? thumbnail;
  
  // Pexels specific
  final String caption;

  VideoModel({
    required this.id,
    required this.url,
    required this.title,
    required this.likes,
    required this.username,
    this.thumbnail,
    required this.caption,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    String url = '';
    String thumbnail = '';
    
    // Check if it's Pexels format
    if (json.containsKey('video_files')) {
       final videoFiles = json['video_files'] as List<dynamic>;
      // Fix OOM/Lag: Pexels 'hd' can be 1080p or 4k which is too heavy for emulators/low-end phones.
      // We prioritize 'sd' (usually 540p/960x540) which offers the best balance of quality/performance.
      // If 'sd' is missing, we look for a light 'hd' (< 1080).
      final videoFile = videoFiles.firstWhere(
        (file) => file['quality'] == 'sd',
        orElse: () => videoFiles.firstWhere(
          (file) => file['quality'] == 'hd' && file['width'] != null && file['width'] <= 720,
          orElse: () => videoFiles.first,
        ),
      );
      url = videoFile['link'];
      thumbnail = json['image'];
      
      return VideoModel(
        id: json['id'].toString(),
        url: url,
        title: 'Video by ${json['user']['name']}',
        likes: 0, // Pexels doesn't give likes easily in this endpoint
        username: json['user']['name'],
        thumbnail: thumbnail,
        caption: 'Video by ${json['user']['name']}',
      );
    } else {
      // Fallback or other source
      return VideoModel(
        id: json['id'] as String,
        url: json['url'] as String,
        title: json['title'] as String,
        likes: json['likes'] as int,
        username: json['username'] as String,
        thumbnail: json['thumbnail'] as String?,
        caption: json['title'] as String,
      );
    }
  }
}
