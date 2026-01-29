import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/artist.dart';

import '../../domain/repositories/artist_repository.dart';

class ArtistRepositoryImpl implements ArtistRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Artist>> getArtists() async {
    try {
      final snapshot = await _firestore.collection('artist').get();

      final artists = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] ??= doc.id;
        return ArtistModel.fromJson(data);
      }).toList();

      return artists;
    } catch (e) {
      print('Error loading artists: $e');
      return [];
    }
  }
}