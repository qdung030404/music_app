import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/album_repository.dart';
import '../model/album.dart';

class AlbumRepositoryImp implements AlbumRepository{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Future<List<Album>> getAlbums() async{
    try {
      final snapshot = await _firestore.collection('album').get();
      final albums = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] ??= doc.id;
        return AlbumModel.fromJson(data);
      }).toList();

      return albums;
    }catch (e) {
      print('Error loading albums: $e');
      return [];
    }
  }
}