import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_album/domain/blocs/album_bloc.dart';
import 'package:flutter_album/domain/blocs/album_event.dart';

class AlbumViewModel {
  final AlbumBloc albumBloc;

  AlbumViewModel(this.albumBloc);

  void fetchAlbums() {
    albumBloc.add(FetchAlbums());
  }

  void fetchAlbumDetails(int albumId) {
    albumBloc.add(FetchAlbumDetails(albumId));
  }
}