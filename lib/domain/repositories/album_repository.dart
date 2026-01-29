import 'package:music_app/domain/entities/album_entity.dart';

abstract interface class AlbumRepository {
  Future<List<Album>> getAlbums();
}