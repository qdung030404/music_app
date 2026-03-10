import 'dart:async';
import 'package:music_app/domain/entities/song_entity.dart';
import 'package:music_app/domain/entities/album_entity.dart';
import 'package:music_app/domain/usecases/get_songs.dart';
import 'package:music_app/domain/usecases/get_album.dart';
import 'package:music_app/data/repository/song_repository.dart';
import 'package:music_app/data/repository/album_repository.dart';

class ArtistDetailViewModel {
  final GetSongs _getSongs;
  final GetAlbums _getAlbums;
  final String artistId;

  final StreamController<List<Song>> songsController = StreamController<List<Song>>();
  final StreamController<List<Album>> albumsController = StreamController<List<Album>>();

  ArtistDetailViewModel({required this.artistId})
      : _getSongs = GetSongs(SongRepositoryImpl()),
        _getAlbums = GetAlbums(AlbumRepositoryImp());

  Future<void> loadArtistData() async {
    await Future.wait([
      loadArtistSongs(),
      loadArtistAlbums(),
    ]);
  }

  Future<void> loadArtistSongs() async {
    final allSongs = await _getSongs();
    if (allSongs != null) {
      final artistSongs = allSongs.where((song) => song.artistId == artistId).toList();
      songsController.add(artistSongs);
    }
  }

  Future<void> loadArtistAlbums() async {
    final allAlbums = await _getAlbums();
    if (allAlbums.isNotEmpty) {
      final artistAlbums = allAlbums.where((album) => album.artistId == artistId).toList();
      albumsController.add(artistAlbums);
    }
  }

  void dispose() {
    songsController.close();
    albumsController.close();
  }
}
