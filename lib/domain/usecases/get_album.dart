import '../entities/album_entity.dart';
import '../repositories/album_repository.dart';

class GetAlbums {
  final AlbumRepository _repository;

  GetAlbums(this._repository);

  Future<List<Album>> call() async {
    return await _repository.getAlbums();
  }
}
