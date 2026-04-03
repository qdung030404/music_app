import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/song.dart';

class DownloadService {
  final Dio _dio = Dio();

  // Yêu cầu quyền lưu trữ (Storage permission)
  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      if (androidInfo.version.sdkInt >= 33) {
        // Android 13 trở lên
        final audioStatus = await Permission.audio.request();
        return audioStatus.isGranted;
      } else {
        // Android 12 trở xuống
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }
    return true; // iOS thường được cấp thông qua Info.plist, nhưng có thể check thêm nếu cần
  }

  // Lấy đường dẫn thư mục tải xuống
  Future<String?> _getDownloadDirectory() async {
    Directory? directory;
    if (Platform.isAndroid) {
      // Lưu vào thư mục Downloads của hệ thống
      directory = Directory('/storage/emulated/0/Download/MusicApp');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
    } else {
      // Cho iOS
      directory = await getApplicationDocumentsDirectory();
    }
    return directory.path;
  }

  // Tải 1 bài hát. Trả về: 1 (Tải thành công), 2 (Đã tồn tại), 0 (Lỗi)
  Future<int> downloadSong(Song song, {
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final hasPermission = await _requestPermission();
      if (!hasPermission) {
        print('Không có quyền lưu trữ');
        return 0;
      }

      final dirPath = await _getDownloadDirectory();
      if (dirPath == null) return 0;

      // Xử lý tên file (lọc các ký tự đặc biệt)
      final safeTitle = song.title.replaceAll(RegExp(r'[\\/:*?"<>|]'), ' ');
      final savePath = '$dirPath/$safeTitle.mp3';

      // Kiểm tra file đã tồn tại chưa
      if (File(savePath).existsSync()) {
        print('Bài hát đã tồn tại: $savePath');
        return 2; // 2 đại diện cho "Đã tồn tại"
      }

      await _dio.download(
        song.source,
        savePath,
        onReceiveProgress: onReceiveProgress,
      );

      // Lưu metadata bài hát vào SharedPreferences
      await _saveSongMetadata(song, savePath);

      print('Tải thành công: $savePath');
      return 1; // 1 đại diện cho "Tải thành công"
    } catch (e) {
      print('Lỗi khi tải bài hát ${song.title}: $e');
      return 0; // 0 đại diện cho "Lỗi"
    }
  }

  // Tải nhiều bài hát
  Future<void> downloadMultipleSongs(List<Song> songs, {
    Function(int current, int total)? onProgress,
    Function()? onCompleted,
  }) async {
    int successCount = 0;
    for (int i = 0; i < songs.length; i++) {
      final result = await downloadSong(songs[i]);
      if (result == 1) successCount++;

      if (onProgress != null) {
        onProgress(i + 1, songs.length);
      }
    }

    if (onCompleted != null) {
      onCompleted();
    }
    print('Đã tải xong $successCount/${songs.length} bài hát.');
  }

  // Lưu thông tin bài hát vào danh sách tải xuống
  Future<void> _saveSongMetadata(Song song, String localPath) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> downloadedSongs =
        prefs.getStringList('downloaded_songs') ?? [];

    // Tạo bản sao của song để sửa source thành đường dẫn local
    final songModel = SongModel(
      id: song.id,
      title: song.title,
      albumId: song.albumId,
      artistId: song.artistId,
      albumName: song.albumName,
      artistName: song.artistName,
      source: localPath,
      // Quan trọng: lưu đường dẫn local để phát lại không cần mạng
      image: song.image,
      duration: song.duration,
    );

    // Kiểm tra xem bài hát đã có trong danh sách chưa
    bool exists = false;
    for (int i = 0; i < downloadedSongs.length; i++) {
      final decoded = json.decode(downloadedSongs[i]);
      if (decoded['id'] == song.id) {
        exists = true;
        break;
      }
    }

    if (!exists) {
      downloadedSongs.add(json.encode(songModel.toJson()));
      await prefs.setStringList('downloaded_songs', downloadedSongs);
    }
  }

  // Lấy danh sách bài hát đã tải
  static Future<List<Song>> getDownloadedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> data = prefs.getStringList('downloaded_songs') ?? [];

    List<Song> songs = [];
    for (String item in data) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(item);
        final song = SongModel.fromJson(jsonMap);

        // Kiểm tra xem file có thực sự tồn tại trên máy không
        if (File(song.source).existsSync()) {
          songs.add(song);
        }
      } catch (e) {
        print('Lỗi parse bài hát đã tải: $e');
      }
    }
    return songs;
  }
}
