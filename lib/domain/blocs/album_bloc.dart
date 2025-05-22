import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_album/data/models/album.dart';
import 'package:flutter_album/data/models/photo.dart';
import 'package:flutter_album/data/repositories/album_repository.dart';
import 'package:flutter_album/domain/blocs/album_event.dart';
import 'package:flutter_album/domain/blocs/album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository albumRepository;

  List<Album> _cachedAlbums = []; // optional: to persist albums for reuse

  AlbumBloc({required this.albumRepository}) : super(AlbumInitial()) {
    on<FetchAlbums>(_onFetchAlbums);
    on<FetchAlbumDetails>(_onFetchAlbumDetails);
    print('AlbumBloc initialized');
  }

  Future<void> _onFetchAlbums(FetchAlbums event, Emitter<AlbumState> emit) async {
    print('Fetching albums...');
    emit(AlbumLoading());
    try {
      final albums = await albumRepository.fetchAlbums();
      print('Fetched ${albums.length} albums');
      _cachedAlbums = albums; // cache for reuse
      emit(AlbumLoaded(albums: albums));
    } catch (e) {
      print('Error fetching albums: $e');
      emit(AlbumError(message: e.toString()));
    }
  }

  Future<void> _onFetchAlbumDetails(FetchAlbumDetails event, Emitter<AlbumState> emit) async {
    print('Fetching album details for album ${event.albumId}...');
    emit(AlbumDetailsLoading());
    try {
      final photos = await albumRepository.fetchPhotos(event.albumId);
      print('Fetched ${photos.length} photos for album ${event.albumId}');
      
      if (photos.isEmpty) {
        print('No photos found for album ${event.albumId}');
        emit(AlbumDetailsLoaded(
          albumId: event.albumId,
          photos: [],
        ));
        return;
      }

      // Verify we have valid photos
      final validPhotos = photos.where((photo) => 
        photo.url.isNotEmpty && photo.thumbnailUrl.isNotEmpty
      ).toList();

      print('Found ${validPhotos.length} valid photos out of ${photos.length} total photos');
      
      emit(AlbumDetailsLoaded(
        albumId: event.albumId,
        photos: validPhotos,
      ));
    } catch (e) {
      print('Error fetching album details: $e');
      emit(AlbumError(message: e.toString()));
    }
  }
}
