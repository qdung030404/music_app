import '../entities/song_entity.dart';

abstract interface class SongRepository {
  Future<List<Song>?> getSongs();
}
