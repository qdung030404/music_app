import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_app/data/model/playlist.dart';
import 'package:music_app/domain/repositories/playlist_repository.dart';

class PlaylistRepositoryImp implements PlaylistRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Playlist>> getPlaylist() async {
    try {
      final snapshot = await _firestore.collection('playlists').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] ??= doc.id;
        return PlaylistModel.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error loading playlists: $e');
      return [];
    }
  }
}
