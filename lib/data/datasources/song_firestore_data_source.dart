import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/model/song.dart';

/// Firestore data source for songs.
class SongFirestoreDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Song>?> getData() async {
    try {
      final snapshot = await _firestore.collection('songs').get();

      final songs = snapshot.docs.map((doc) {
        final data = doc.data();
        return SongModel.fromJson(data);
      }).toList();

      // Resolve artist & album display data
      final artistIds = songs
          .map((s) => s.artistId)
          .where((id) => id.trim().isNotEmpty)
          .toSet()
          .toList();
      final albumIds = songs
          .map((s) => s.albumId)
          .where((id) => id.trim().isNotEmpty)
          .toSet()
          .toList();

      // Join artist
      if (artistIds.isNotEmpty) {
        final artistSnap = await _firestore.collection('artist').get();
        final Map<String, String> artistNameById = {
          for (final doc in artistSnap.docs)
            doc.id: ((doc.data()['name'] ??
                        doc.data()['name'] ??
                        doc.data()['title']) ??
                    '')
                .toString(),
        };

        for (final s in songs) {
          final name = artistNameById[s.artistId];
          if (name != null && name.trim().isNotEmpty) {
            s.artistName = name;
          }
        }
      }

      // Join album
      if (albumIds.isNotEmpty) {
        final albumSnap = await _firestore.collection('album').get();

        final Map<String, String> albumNameById = {};
        for (final doc in albumSnap.docs) {
          final data = doc.data();
          final docId = doc.id;
          final fieldId = (data['id'] ?? '').toString();
          final title = (data['title'] ?? '').toString();

          if (title.isEmpty) continue;

          if (docId.isNotEmpty) {
            albumNameById[docId] = title;
          }
          if (fieldId.isNotEmpty) {
            albumNameById[fieldId] = title;
          }
        }

        for (final s in songs) {
          final name = albumNameById[s.albumId];
          if (name != null && name.trim().isNotEmpty) {
            s.albumName = name;
          }
        }
      }

      return songs;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}

