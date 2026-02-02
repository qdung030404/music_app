import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:music_app/data/repository/song_repository.dart';
import 'package:music_app/domain/usecases/get_songs.dart';
import '../../../domain/entities/song_entity.dart';

class SongViewModel {
  final GetSongs _getSongs;
  final String albumId;

  // BehaviorSubject holds the most recent value and emits it to new listeners
  final _songsSubject = BehaviorSubject<List<Song>>();
  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);

  // Expose streams for UI to listen to
  Stream<List<Song>> get songsStream => _songsSubject.stream;
  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;

  // Convenience getters for current values
  List<Song> get currentSongs => _songsSubject.valueOrNull ?? [];
  bool get isLoading => _isLoadingSubject.value;

  SongViewModel({required this.albumId})
      : _getSongs = GetSongs(SongRepositoryImpl());

  Future<void> loadAlbumSongs() async {
    // Prevent multiple simultaneous loads
    if (_isLoadingSubject.value) return;

    _isLoadingSubject.add(true);
    try {
      final allSongs = await _getSongs();
      if (allSongs != null) {
        // Filter songs by albumId
        final albumSongs = allSongs.where((song) => song.albumId == albumId).toList();
        _songsSubject.add(albumSongs);
      } else {
        _songsSubject.add([]);
      }
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