import 'dart:async';

import 'package:music_app/domain/entities/artist_entity.dart';
import 'package:music_app/domain/entities/song_entity.dart';
import 'package:music_app/domain/usecases/get_artists.dart';
import 'package:music_app/domain/usecases/get_songs.dart';
import 'package:music_app/data/repository/artist_repository.dart';
import 'package:music_app/data/repository/song_repository.dart';

class HomeViewModel {
  final GetSongs _getSongs;
  final GetArtists _getArtists;

  final StreamController<List<Song>> songsController =
      StreamController<List<Song>>();
  final StreamController<List<Artist>> artistsController =
      StreamController<List<Artist>>();

  HomeViewModel()
      : _getSongs = GetSongs(SongRepositoryImpl()),
        _getArtists = GetArtists(ArtistRepositoryImpl());

  Future<void> loadSongs() async {
    final songs = await _getSongs();
    if (songs != null && songs.isNotEmpty) {
      songsController.add(songs);
    }
  }

  Future<void> loadArtists() async {
    final artists = await _getArtists();
    if (artists.isNotEmpty) {
      artistsController.add(artists);
    }
  }

  void dispose() {
    songsController.close();
    artistsController.close();
  }
}

