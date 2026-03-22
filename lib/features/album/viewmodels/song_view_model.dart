import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:music_app/data/datasources/jamendo_service.dart';
import 'package:music_app/data/model/song.dart';
class SongViewModel {
  final String albumId;

  // BehaviorSubject sẽ lưu giữ lại giá trị mới nhất, và tự động phát lại (gửi lại) giá trị đó cho những người mới bắt đầu lắng nghe.
  final _songsSubject = BehaviorSubject<List<Song>>();
  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);

  // Hiển thị các luồng dữ liệu để giao diện người dùng có thể lắng nghe.
  Stream<List<Song>> get songsStream => _songsSubject.stream;
  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;

  // Các hàm lấy dữ liệu tiện ích (giúp truy cập nhanh giá trị hiện tại)
  List<Song> get currentSongs => _songsSubject.valueOrNull ?? [];
  bool get isLoading => _isLoadingSubject.value;

  SongViewModel({required this.albumId});

  Future<void> loadAlbumSongs() async {
    if (_isLoadingSubject.value) return;

    _isLoadingSubject.add(true);
    try {
      final jamendo = JamendoService();
      final songsData = await jamendo.fetchTracksByAlbumId(albumId);
      
      final List<Song> albumSongs = songsData.map<Song>((e) => SongModel(
        id: e['id']?.toString() ?? '',
        title: e['name'] ?? 'Unknown',
        albumId: e['album_id']?.toString() ?? '',
        artistId: e['artist_id']?.toString() ?? '',
        albumName: e['album_name'],
        artistName: e['artist_name'],
        source: e['audio'] ?? '',
        image: e['image'] ?? e['album_image'] ?? '',
        duration: e['duration'] ?? 180,
      )).toList();
      
      _songsSubject.add(albumSongs);
    } catch (e) {
      _songsSubject.addError(e);
    } finally {
      _isLoadingSubject.add(false);
    }
  }

  void dispose() {
    _songsSubject.close();
    _isLoadingSubject.close();
  }
}