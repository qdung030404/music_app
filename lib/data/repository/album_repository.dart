import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/album_repository.dart';
import '../model/album.dart';

class AlbumRepositoryImp implements AlbumRepository{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Future<List<Album>> getAlbums() async {
    try {
      final snapshot = await _firestore.collection('album').get();
      final albums = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] ??= doc.id;
        return AlbumModel.fromJson(data);
      }).toList();

      // Resolve artist names
      final artistIds = albums
          .map((a) => a.artistId)
          .where((id) => id.trim().isNotEmpty)
          .toSet()
          .toList();

      if (artistIds.isNotEmpty) {
        final artistSnap = await _firestore.collection('artist').get();
        final Map<String, String> artistNameById = {
          for (final doc in artistSnap.docs)
            doc.id: (doc.data()['name'] ?? doc.data()['title'] ?? '').toString(),
        };

        for (final album in albums) {
          final name = artistNameById[album.artistId];
          if (name != null && name.trim().isNotEmpty) {
            album.artistName = name;
          }
        }
      }

      return albums;
    } catch (e) {
      print('Error loading albums: $e');
      return [];
    }
  }
}