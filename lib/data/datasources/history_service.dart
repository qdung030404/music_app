import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/song.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  Future<void> addToHistory(Song song) async {
    final uid = _userId;
    if (uid == null) {
      print('HistoryService: Cannot add to history, user not logged in.');
      return;
    }

    try {
      final userRef = _firestore.collection('users').doc(uid);
      final historyRef = userRef.collection('history');

      // Create/Update song data
      final songData = {
        'id': song.id,
        'title': song.title,
        'albumId': song.albumId,
        'artistId': song.artistId,
        'albumName': song.albumName,
        'artistName': song.artistName,
        'source': song.source,
        'image': song.image,
        'duration': song.duration,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Write to Firestore Batch/Set
      // We also update a dummy field in the user document to ensure it's visible in the console
      await _firestore.runTransaction((transaction) async {
        transaction.set(userRef, {'lastActivity': FieldValue.serverTimestamp()}, SetOptions(merge: true));
        transaction.set(historyRef.doc(song.id), songData);
      });
      
      print('HistoryService: Successfully saved ${song.title} to history for user $uid');
    } catch (e) {
      print('HistoryService Error: $e');
    }
  }

  Stream<List<Song>> getHistoryStream() {
    final uid = _userId;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('history')
        .orderBy('timestamp', descending: true)
        .limit(10) // Fetch a bit more than 5 just in case
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return SongModel.fromJson(doc.data());
      }).toList();
    });
  }
}
