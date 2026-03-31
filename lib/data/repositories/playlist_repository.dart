import 'package:music_app/data/models/playlist.dart';

abstract interface class PlaylistRepository {
  Future<List<Playlist>> getPlaylist();
}
