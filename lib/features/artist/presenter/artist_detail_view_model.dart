import 'dart:async';

import 'package:music_app/data/datasources/jamendo_service.dart';
import 'package:music_app/data/models/album.dart';
import 'package:music_app/data/models/song.dart';
import 'package:rxdart/rxdart.dart';

class ArtistDetailViewModel {
  final String artistId;

  final BehaviorSubject<List<Song>> songsController =
      BehaviorSubject<List<Song>>();
  final BehaviorSubject<List<Album>> albumsController =
      BehaviorSubject<List<Album>>();

  ArtistDetailViewModel({required this.artistId});

  Future<void> loadArtistData() async {
    await Future.wait([
      loadArtistSongs(),
      loadArtistAlbums(),
    ]);
  }

  Future<void> loadArtistSongs() async {
    try {
      final jamendo = JamendoService();
      final songsData = await jamendo.fetchTracksByArtistId(artistId);

      final List<Song> artistSongs = songsData
          .map<Song>(
            (e) => SongModel(
              id: e['id']?.toString() ?? '',
              title: e['name'] ?? 'Unknown',
              albumId: e['album_id']?.toString() ?? '',
              artistId: e['artist_id']?.toString() ?? '',
              albumName: e['album_name'],
              artistName: e['artist_name'],
              source: e['audio'] ?? '',
              image: e['image'] ?? e['album_image'] ?? '',
              duration: e['duration'] ?? 180,
            ),
          )
          .toList();

      songsController.add(artistSongs);
    } catch (e) {}
  }

  Future<void> loadArtistAlbums() async {
    try {
      final jamendo = JamendoService();
      final albumsData = await jamendo.fetchAlbumsByArtistId(artistId);
      final List<Album> artistAlbums = albumsData
          .map<Album>(
            (e) => AlbumModel(
              id: e['id']?.toString() ?? '',
              albumTitle: e['name'] ?? 'Unknown',
              artistId: e['artist_id']?.toString() ?? '',
              artistName: e['artist_name'] ?? 'Unknown',
              image: e['image'] ?? '',
            ),
          )
          .toList();
      albumsController.add(artistAlbums);
    } catch (e) {
      print(e);
    }
  }

  void dispose() {
    songsController.close();
    albumsController.close();
  }
}
