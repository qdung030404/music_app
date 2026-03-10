import 'package:device_info_plus/device_info_plus.dart';
import 'package:disk_space_plus/disk_space_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'download_service.dart';

class DeviceStorageService {
  static Future<Map<String, String>> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return {
        'platform': 'Android',
        'model': androidInfo.model,
        'version': androidInfo.version.release,
        'manufacturer': androidInfo.manufacturer,
      };
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return {
        'platform': 'iOS',
        'model': iosInfo.utsname.machine,
        'version': iosInfo.systemVersion,
        'name': iosInfo.name,
      };
    } else {
      return {'platform': 'unknown'};
    }
  }
  static Future<Map<String, double>> getStorageInfo() async {
    DiskSpacePlus diskSpacePlus = DiskSpacePlus();
    // DiskSpace trả về MB (double)
    final totalMB = await diskSpacePlus.getTotalDiskSpace ?? 0.0;
    final freeMB  = await diskSpacePlus.getFreeDiskSpace  ?? 0.0;

    double downloaded = 0.0;
    try {
      final songs = await DownloadService.getDownloadedSongs();
      for (var song in songs) {
        final file = File(song.source);
        if (file.existsSync()) {
          downloaded += file.lengthSync() / (1024 * 1024);
        }
      }
    } catch (e) {
      print('Lỗi tính dung lượng nhạc tải: $e');
    }

    double cache = 0.0;
    try {
      final tempDir = await getTemporaryDirectory();
      cache = (await _getDirSize(tempDir)) / (1024 * 1024);
    } catch (e) {
      print('Lỗi tính dung lượng bộ nhớ tạm: $e');
    }

    final other = (totalMB - freeMB - downloaded - cache).clamp(0.0, double.infinity);

    return {
      'total': totalMB,
      'free': freeMB,
      'downloaded': downloaded,
      'cache': cache,
      'other': other,
    };
  }

  // Hàm đệ quy tính tổng kích thước các file trong thư mục
  static Future<int> _getDirSize(Directory dir) async {
    int totalSize = 0;
    try {
      if (dir.existsSync()) {
        await for (var entity in dir.list(recursive: true, followLinks: false)) {
          if (entity is File) {
            totalSize += await entity.length();
          }
        }
      }
    } catch (e) {
      print('Lỗi khi đọc kích thước thư mục: $e');
    }
    return totalSize;
  }

  // Xóa bộ nhớ tạm (Cache)
  static Future<void> clearCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        final dirList = tempDir.listSync(recursive: true, followLinks: false);
        for (var entity in dirList) {
          if (entity is File) {
            try {
              entity.deleteSync();
            } catch (e) {
              // Ignore file locked errors
            }
          }
        }
      }
    } catch (e) {
      print('Lỗi khi xóa bộ nhớ tạm: $e');
    }
  }
}

