import '../entities/playlist_entity.dart';
import '../repositories/playlist_repository.dart';

class GetPlaylist {
  final PlaylistRepository _repository;

  GetPlaylist(this._repository);

  Future<List<Playlist>> call() async {
    return await _repository.getPlaylist();
  }
}
