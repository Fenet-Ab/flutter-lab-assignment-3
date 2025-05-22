import 'package:equatable/equatable.dart';
import 'package:flutter_album/data/models/album.dart';
import 'package:flutter_album/data/models/photo.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();

  @override
  List<Object> get props => [];
}

class AlbumInitial extends AlbumState {
  const AlbumInitial();
}

class AlbumLoading extends AlbumState {
  const AlbumLoading();
}

class AlbumDetailsLoading extends AlbumState {
  const AlbumDetailsLoading();
}

class AlbumLoaded extends AlbumState {
  final List<Album> albums;

  const AlbumLoaded({required this.albums});

  @override
  List<Object> get props => [albums];
}

class AlbumDetailsLoaded extends AlbumState {
  final int albumId;
  final List<Photo> photos;

  const AlbumDetailsLoaded({
    required this.albumId,
    required this.photos,
  });

  @override
  List<Object> get props => [albumId, photos];
}

class AlbumError extends AlbumState {
  final String message;

  const AlbumError({required this.message});

  @override
  List<Object> get props => [message];
}
