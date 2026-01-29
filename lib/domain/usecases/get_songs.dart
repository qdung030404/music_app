import '../entities/song_entity.dart';
import '../repositories/song_repository.dart';

class GetSongs {
  final SongRepository _repository;

  GetSongs(this._repository);

  Future<List<Song>?> call() async {
    return await _repository.getSongs();
  }
}
