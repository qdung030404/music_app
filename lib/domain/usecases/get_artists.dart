import '../entities/artist_entity.dart';
import '../repositories/artist_repository.dart';

class GetArtists {
  final ArtistRepository _repository;

  GetArtists(this._repository);

  Future<List<Artist>> call() async {
    return await _repository.getArtists();
  }
}
