import 'package:equatable/equatable.dart';

class Album extends Equatable {
  final int id;
  final int userId;
  final String title;
  String? thumbnailUrl;

  Album({
    required this.id,
    required this.userId,
    required this.title,
    this.thumbnailUrl,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
    );
  }

  @override
  List<Object?> get props => [id, userId, title, thumbnailUrl];
} 