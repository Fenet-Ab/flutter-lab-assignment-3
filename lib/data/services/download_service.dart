import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  final Dio _dio = Dio();

  Future<String?> downloadFile(String url, String fileName) async {
    try {
      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('Storage permission not granted');
      }

      // Get the download directory
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Could not access storage directory');
      }

      // Create a directory for downloads if it doesn't exist
      final downloadDir = Directory('${directory.path}/PhotoAlbum');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      // Create the file path
      final filePath = '${downloadDir.path}/$fileName';

      // Download the file
      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            // You can implement progress tracking here if needed
            final progress = (received / total * 100).toStringAsFixed(0);
            print('Download progress: $progress%');
          }
        },
      );

      return filePath;
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }
} 