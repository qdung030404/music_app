import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:music_app/data/repository/song_repository.dart';
import 'package:music_app/domain/usecases/get_songs.dart';
import '../../../data/datasources/user_activity_service.dart';
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

  void loadPlaylistSongs() {
    _isLoadingSubject.add(true);
    final service = UserActivityService();
    service.getPlaylistSongsStream(playlistId).listen(
      (songs) {
        _songsSubject.add(songs);
        _isLoadingSubject.add(false);
      },
      onError: (error) {
        _songsSubject.addError(error);
        _isLoadingSubject.add(false);
      },
    );
  }

  void dispose() {
    _songsSubject.close();
    _isLoadingSubject.close();
  }
}
