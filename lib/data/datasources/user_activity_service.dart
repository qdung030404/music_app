import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_app/data/model/artist.dart';
import '../model/song.dart';

class UserActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  Future<void> addtoFollow(Artist artist) async{
    final uid = _userId;
    if(uid == null){
      return;
    }
    try{
      final userRef = _firestore.collection('users').doc(uid);
      final followRef = userRef.collection('follow');
      final artistData = {
        'id': artist.id,
        'name': artist.name,
        'avatar': artist.avatar,
        'timestamp': FieldValue.serverTimestamp(),
      };
      await _firestore.runTransaction((transaction) async {
        transaction.set(userRef, {'lastActivity': FieldValue.serverTimestamp()}, SetOptions(merge: true));
        transaction.set(followRef.doc(artist.id), artistData);
      });
    }catch (e){
      print('UserActivityService Error: $e');
    }
  }

  Future<bool> isFollowing(String artistId) async {
    final uid = _userId;
    if (uid == null) return false;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('follow')
          .doc(artistId)
          .get();
      return doc.exists;
    } catch (e) {
      print('UserActivityService Error checking follow: $e');
      return false;
    }
  }

  Future<void> addToHistory(Song song) async {
    final uid = _userId;
    if (uid == null) {
      print('UserActivityService: Cannot add to history, user not logged in.');
      return;
    }
    try {
      final userRef = _firestore.collection('users').doc(uid);
      final historyRef = userRef.collection('history');

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

      await _firestore.runTransaction((transaction) async {
        transaction.set(userRef, {'lastActivity': FieldValue.serverTimestamp()}, SetOptions(merge: true));
        transaction.set(historyRef.doc(song.id), songData);
      });
      
      print('UserActivityService: Successfully saved ${song.title} to history for user $uid');
    } catch (e) {
      print('UserActivityService Error: $e');
    }
  }

  Future<void> addToFavorite(Song song) async {
    final uid = _userId;
    if (uid == null) {
      print('UserActivityService: Cannot add to favorites, user not logged in.');
      return;
    }

    try {
      final userRef = _firestore.collection('users').doc(uid);
      final favoriteRef = userRef.collection('favorites');

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

      await _firestore.runTransaction((transaction) async {
        transaction.set(userRef, {'lastActivity': FieldValue.serverTimestamp()}, SetOptions(merge: true));
        transaction.set(favoriteRef.doc(song.id), songData);
      });
      
      print('UserActivityService: Successfully saved ${song.title} to favorites for user $uid');
    } catch (e) {
      print('UserActivityService Error: $e');
    }
  }

  Future<void> removeItem(String Id, String collection) async {
    final uid = _userId;
    if (uid == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection(collection)
          .doc(Id)
          .delete();
      print('UserActivityService: Successfully removed item $Id from $collection');
    } catch (e) {
      print('UserActivityService Error removing item: $e');
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

  Stream<List<Song>> getFavoritesStream() {
    final uid = _userId;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return SongModel.fromJson(doc.data());
      }).toList();
    });
  }

  Future<bool> isFavorite(String songId) async {
    final uid = _userId;
    if (uid == null) return false;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('favorites')
          .doc(songId)
          .get();
      return doc.exists;
    } catch (e) {
      print('UserActivityService Error checking favorite: $e');
      return false;
    }
  }
}
