import 'dart:async';
import 'package:music_app/domain/entities/artist_entity.dart';
import 'package:music_app/domain/entities/song_entity.dart';
import 'package:music_app/domain/usecases/get_artists.dart';
import 'package:music_app/domain/usecases/get_songs.dart';
import 'package:music_app/data/repository/artist_repository.dart';
import 'package:music_app/data/repository/song_repository.dart';

import '../../../data/repository/album_repository.dart';
import '../../../domain/entities/album_entity.dart';
import '../../../domain/usecases/get_album.dart';

class HomeViewModel {
  final GetSongs _getSongs;
  final GetArtists _getArtists;
  final GetAlbums _getAlbums;

  final StreamController<List<Song>> songsController =
      StreamController<List<Song>>();
  final StreamController<List<Artist>> artistsController =
      StreamController<List<Artist>>();
  final StreamController<List<Album>> albumController =
      StreamController<List<Album>>();


  HomeViewModel()
      : _getSongs = GetSongs(SongRepositoryImpl()),
        _getArtists = GetArtists(ArtistRepositoryImpl()),
        _getAlbums = GetAlbums(AlbumRepositoryImp());

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
  Future<void> loadAlbum() async {
    final albums = await _getAlbums();
    if (albums.isNotEmpty) {
      albumController.add(albums);
    }
  }
  void dispose() {
    songsController.close();
    artistsController.close();
    albumController.close();
  }
}

