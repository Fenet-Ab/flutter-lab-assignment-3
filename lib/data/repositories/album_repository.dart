import 'dart:convert';
import 'package:flutter_album/data/models/album.dart';
import 'package:flutter_album/data/models/photo.dart';
import 'package:http/http.dart' as http;

class AlbumRepository {
  final String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Album>> fetchAlbums() async {
    try {
      print('Fetching albums...');
      // First fetch all photos
      final photosResponse = await http.get(Uri.parse('$_baseUrl/photos'));
      print('Photos response status: ${photosResponse.statusCode}');
      if (photosResponse.statusCode != 200) {
        throw Exception('Failed to load photos');
      }
      
      // Create a map of album ID to first photo
      final List<dynamic> photosData = jsonDecode(photosResponse.body);
      print('Fetched ${photosData.length} photos');
      final Map<int, String> albumThumbnails = {};
      for (var photo in photosData) {
        final albumId = photo['albumId'] as int;
        if (!albumThumbnails.containsKey(albumId)) {
          // Use Lorem Picsum for thumbnails
          final photoId = photo['id'] as int;
          final thumbnailUrl = 'https://picsum.photos/id/${photoId + 100}/150/150';
          print('Album $albumId thumbnail URL: $thumbnailUrl');
          albumThumbnails[albumId] = thumbnailUrl;
        }
      }

      // Then fetch albums
      final response = await http.get(Uri.parse('$_baseUrl/albums'));
      print('Albums response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Fetched ${data.length} albums');
        final albums = data.map((json) {
          final album = Album.fromJson(json);
          album.thumbnailUrl = albumThumbnails[album.id];
          print('Album ${album.id} title: ${album.title}, thumbnail: ${album.thumbnailUrl}');
          return album;
        }).toList();
        return albums;
      } else {
        throw Exception('Failed to load albums');
      }
    } catch (e) {
      print('Error in fetchAlbums: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<List<Photo>> fetchPhotos(int albumId) async {
    try {
      print('Fetching photos for album $albumId...');
      final response = await http.get(Uri.parse('$_baseUrl/photos?albumId=$albumId'));
      print('Photos response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Fetched ${data.length} photos for album $albumId');
        
        if (data.isEmpty) {
          print('No photos found for album $albumId');
          return [];
        }

        final photos = data.map((json) {
          final id = json['id'] as int;
          // Use Lorem Picsum with a fixed ID and no random parameter
          final url = 'https://picsum.photos/id/${id + 100}/600/600';
          final thumbnailUrl = 'https://picsum.photos/id/${id + 100}/150/150';
          print('Transformed URL for photo $id: $url');
          
          return Photo(
            id: id,
            albumId: json['albumId'] as int,
            title: json['title'] as String,
            url: url,
            thumbnailUrl: thumbnailUrl,
          );
        }).toList();

        print('Final photo URLs: ${photos.map((p) => p.url).toList()}');
        return photos;
      } else {
        print('Failed to load photos. Status code: ${response.statusCode}');
        throw Exception('Failed to load photos');
      }
    } catch (e) {
      print('Error in fetchPhotos: $e');
      throw Exception('Network error: $e');
    }
  }
}
