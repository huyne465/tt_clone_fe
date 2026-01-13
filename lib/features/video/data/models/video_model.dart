class VideoModel {
  final String id;
  final String url;
  final String title;
  final int likes;
  final String username;
  final String? thumbnail;
  final String caption;
  final int comments;
  final int shares;
  final String songName;
  final String profilePhoto;

  VideoModel({
    required this.id,
    required this.url,
    required this.title,
    required this.likes,
    required this.username,
    this.thumbnail,
    required this.caption,
    this.comments = 0,
    this.shares = 0,
    this.songName = 'Original Sound',
    this.profilePhoto = 'https://files.fullstack.edu.vn/f8-prod/user_avatars/1/623d4b2d95cec.png',
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    // YouTube API Handler
    if (json.containsKey('snippet') && json.containsKey('id')) {
      final snippet = json['snippet'];
      final statistics = json['statistics'] ?? {};
      final String videoId = json['id'] is String ? json['id'] : (json['id']['videoId'] ?? '');
      
      return VideoModel(
        id: videoId,
        url: 'https://www.youtube.com/shorts/$videoId',
        title: snippet['title'] ?? '',
        likes: int.tryParse(statistics['likeCount'] ?? '0') ?? 0,
        username: snippet['channelTitle'] ?? '',
        thumbnail: snippet['thumbnails']?['high']?['url'] ?? snippet['thumbnails']?['default']?['url'],
        caption: snippet['title'] ?? '',
        comments: int.tryParse(statistics['commentCount'] ?? '0') ?? 0,
        shares: 0, // Not available in standard snippet/stats
        songName: 'Original Sound', // Could extract from topicDetails if needed
        profilePhoto: snippet['thumbnails']?['default']?['url'] ?? 'https://files.fullstack.edu.vn/f8-prod/user_avatars/1/623d4b2d95cec.png', // Fallback, getting channel avatar requires separate call
      );
    }

    // Existing Pexels Handler (Legacy)
    if (json.containsKey('video_files')) {
       final videoFiles = json['video_files'] as List<dynamic>;
      final videoFile = videoFiles.firstWhere(
        (file) => file['quality'] == 'sd',
        orElse: () => videoFiles.firstWhere(
          (file) => file['quality'] == 'hd' && file['width'] != null && file['width'] <= 720,
          orElse: () => videoFiles.first,
        ),
      );
      
      return VideoModel(
        id: json['id'].toString(),
        url: videoFile['link'],
        title: 'Video by ${json['user']['name']}',
        likes: 0, 
        username: json['user']['name'],
        thumbnail: json['image'],
        caption: 'Video by ${json['user']['name']}',
      );
    } 
    
    // Generic Fallback
    return VideoModel(
      id: json['id']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      likes: json['likes'] is int ? json['likes'] : 0,
      username: json['username']?.toString() ?? 'User',
      thumbnail: json['thumbnail']?.toString(),
      caption: json['title']?.toString() ?? '',
    );
  }
}
