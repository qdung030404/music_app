import 'package:music_app/domain/entities/playlist_entity.dart';

abstract interface class PlaylistRepository {
  Future<List<Playlist>> getPlaylist();
}