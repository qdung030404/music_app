import '../entities/artist_entity.dart';

abstract interface class ArtistRepository {
  Future<List<Artist>> getArtists();
}
