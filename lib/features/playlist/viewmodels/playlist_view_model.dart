import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:music_app/data/repository/song_repository.dart';
import 'package:music_app/domain/usecases/get_songs.dart';
import '../../../domain/entities/song_entity.dart';

class PlaylistViewModel {
  final GetSongs _getSongs;
  final String playlistId;

  final _songsSubject = BehaviorSubject<List<Song>>();
  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);

  Stream<List<Song>> get songsStream => _songsSubject.stream;
  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;

  PlaylistViewModel({required this.playlistId})
      : _getSongs = GetSongs(SongRepositoryImpl());

  Future<void> loadPlaylistSongs() async {
    if (_isLoadingSubject.value) return;

    _isLoadingSubject.add(true);
    try {
      // In a real implementation, you would fetch songs from a specific collection
      // or filter them if you have a mapping.
      // For now, we return an empty list as we don't have the mapping yet.
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network
      _songsSubject.add([]);
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
