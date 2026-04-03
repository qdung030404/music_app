import 'dart:async';

import 'package:music_app/data/models/song.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/datasources/user_activity_service.dart';

class PlaylistViewModel {
  final String playlistId;

  final _songsSubject = BehaviorSubject<List<Song>>();
  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);

  Stream<List<Song>> get songsStream => _songsSubject.stream;

  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;

  PlaylistViewModel({required this.playlistId});

  void loadPlaylistSongs() {
    _isLoadingSubject.add(true);
    final service = UserActivityService();
    service
        .getPlaylistSongsStream(playlistId)
        .listen(
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
