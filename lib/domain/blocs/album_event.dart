import 'package:equatable/equatable.dart';

abstract class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object> get props => [];
}

class FetchAlbums extends AlbumEvent {
  const FetchAlbums(); // add const constructor
}

class FetchAlbumDetails extends AlbumEvent {
  final int albumId;

  const FetchAlbumDetails(this.albumId);

  @override
  List<Object> get props => [albumId];
}
