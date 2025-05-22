import 'package:equatable/equatable.dart';

class Photo extends Equatable {
  final int id;
  final int albumId;
  final String title;
  final String url;
  final String thumbnailUrl;

  const Photo({
    required this.id,
    required this.albumId,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    print('Creating Photo from JSON: $json');
    
    final url = json['url'] as String? ?? '';
    final thumbnailUrl = json['thumbnailUrl'] as String? ?? '';
    
    print('Photo URLs - Full: $url, Thumbnail: $thumbnailUrl');
    
    if (url.isEmpty || thumbnailUrl.isEmpty) {
      print('Warning: Empty URLs detected for photo ${json['id']}');
    }

    return Photo(
      id: json['id'] as int,
      albumId: json['albumId'] as int,
      title: json['title'] as String,
      url: url,
      thumbnailUrl: thumbnailUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'albumId': albumId,
      'title': title,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  @override
  List<Object?> get props => [id, albumId, title, url, thumbnailUrl];
} 