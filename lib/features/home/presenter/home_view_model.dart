import 'dart:async';

import 'package:music_app/data/datasources/jamendo_service.dart';
import 'package:music_app/data/models/album.dart';
import 'package:music_app/data/models/artist.dart';
import 'package:music_app/data/models/song.dart';

class HomeViewModel {
  final StreamController<List<Song>> songsController =
      StreamController<List<Song>>();
  final StreamController<List<Artist>> artistsController =
      StreamController<List<Artist>>();
  final StreamController<List<Album>> albumController =
      StreamController<List<Album>>();

  Future<void> loadSongs() async {
    List<Song> allSongs = [];

    try {
      final jamendoService = JamendoService();
      final jamendoData = await jamendoService.fetchPopularTracks();

      final List<Song> jamendoSongs = jamendoData
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

      jamendoSongs.shuffle(); // Đảo trộn ngẫu nhiên danh sách nhạc
      allSongs.addAll(jamendoSongs);
    } catch (e) {
      print("Loi ghep nhac Jamendo: $e");
    }

    if (allSongs.isNotEmpty) {
      songsController.add(allSongs);
    }
  }

  Future<void> loadArtists() async {
    List<Artist> allArtists = [];
    try {
      final jamendoService = JamendoService();
      final jamendoData = await jamendoService.fetchPopularArtists();

      final List<Artist> jamendoArtists = jamendoData
          .where(
            (e) =>
                e['image'] != null && e['image'].toString().trim().isNotEmpty,
          )
          .map<Artist>(
            (e) => ArtistModel(
              id: e['id']?.toString() ?? '',
              name: e['name'] ?? 'Unknown',
              avatar: e['image'] ?? '',
            ),
          )
          .toList();

      jamendoArtists.shuffle(); // Đảo trộn ngẫu nhiên danh sách nghệ sĩ

      allArtists.addAll(jamendoArtists);
    } catch (e) {
      print("Loi ghep Jamendo Artists: $e");
    }

    if (allArtists.isNotEmpty) {
      artistsController.add(allArtists);
    }
  }

  Future<void> loadAlbum() async {
    List<Album> allAlbums = [];
    try {
      final jamendoService = JamendoService();
      final jamendoData = await jamendoService.fetchPopularAlbums();

      final List<Album> jamendoAlbums = jamendoData
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

      jamendoAlbums.shuffle(); // Đảo trộn ngẫu nhiên danh sách Album

      allAlbums.addAll(jamendoAlbums);
    } catch (e) {
      print("Loi ghep Jamendo Albums: $e");
    }

    if (allAlbums.isNotEmpty) {
      albumController.add(allAlbums);
    }
  }

  void dispose() {
    songsController.close();
    artistsController.close();
    albumController.close();
  }
}
