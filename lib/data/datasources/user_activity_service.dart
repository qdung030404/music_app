import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_app/data/models/album.dart';
import 'package:music_app/data/models/artist.dart';

import '../models/playlist.dart';
import '../models/song.dart';
import '../../core/services/notification_service.dart';

class UserActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;
  Future<void> updatePersonalInformation(User refreshedUser, {
    String? displayName,
    String? photoURL,
  }) async {
    final uid = _userId;
    if (uid == null) return;
    try {
      final userRef = _firestore.collection('users').doc(uid);
      final userData = <String, dynamic>{
        'lastActivity': FieldValue.serverTimestamp(),
        if (displayName != null) 'username': displayName,
        if (photoURL != null) 'avatar': photoURL,
      };
      await userRef.set(userData, SetOptions(merge: true));
    } catch (e) {
      print('UserActivityService Error: $e');
    }
  }

  Future<void> addFavoriteAlbum(Album album) async {
    final uid = _userId;
    if (uid == null) {
      return;
    }
    try {
      final userRef = _firestore.collection('users').doc(uid);
      final albumRef = userRef.collection('albums');
      final albumData = {
        'id': album.id,
        'image': album.image,
        'title': album.albumTitle,
        'artistName': album.artistName,
        'timestamp': FieldValue.serverTimestamp(),
      };
      await _firestore.runTransaction((transaction) async {
        transaction.set(userRef, {
          'lastActivity': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        transaction.set(albumRef.doc(album.id), albumData);
      });
    } catch (e) {
      print('UserActivityService Error: $e');
    }
  }

  Stream<List<Album>> getAlbumStream() {
    final uid = _userId;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('albums')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return AlbumModel.fromJson(doc.data());
          }).toList();
        });
  }

  Future<void> addtoFollow(Artist artist) async {
    final uid = _userId;
    if (uid == null) {
      return;
    }
    try {
      final userRef = _firestore.collection('users').doc(uid);
      final followRef = userRef.collection('followed');
      final artistData = {
        'id': artist.id,
        'name': artist.name,
        'avatar': artist.avatar,
        'timestamp': FieldValue.serverTimestamp(),
      };
      await _firestore.runTransaction((transaction) async {
        transaction.set(userRef, {
          'lastActivity': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        transaction.set(followRef.doc(artist.id), artistData);
      });
    } catch (e) {
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
          .collection('followed')
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
        transaction.set(userRef, {
          'lastActivity': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        transaction.set(historyRef.doc(song.id), songData);
      });
    } catch (e) {
      print('UserActivityService Error: $e');
    }
  }

  Future<void> addToFavorite(Song song) async {
    final uid = _userId;
    if (uid == null) {
      print(
        'UserActivityService: Cannot add to favorites, user not logged in.',
      );
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
        transaction.set(userRef, {
          'lastActivity': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        transaction.set(favoriteRef.doc(song.id), songData);
      });
    } catch (e) {
      print('UserActivityService Error: $e');
    }
  }

  Future<void> removeItem(String id, String collection) async {
    final uid = _userId;
    if (uid == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection(collection)
          .doc(id)
          .delete();
      print(
        'UserActivityService: Successfully removed item $id from $collection',
      );
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

  Stream<List<Artist>> getFollowedArtist() {
    final uid = _userId;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('followed')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ArtistModel.fromJson(doc.data());
          }).toList();
        });
  }

  Future<bool> isFavorite(String Id, String collection) async {
    final uid = _userId;
    if (uid == null) return false;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .collection(collection)
          .doc(Id)
          .get();
      return doc.exists;
    } catch (e) {
      print('UserActivityService Error checking favorite: $e');
      return false;
    }
  }

  Future<void> createPlaylist(
    Playlist playlist, {
    bool isPrivate = true,
  }) async {
    final uid = _userId;
    if (uid == null) {
      print(
        'UserActivityService: Cannot add to favorites, user not logged in.',
      );
      return;
    }

    try {
      final userRef = _firestore.collection('users').doc(uid);

      final playlistData = {
        // Changed songData to playlistData
        'id': playlist.id,
        'name': playlist.playlistName,
        'isPrivate': isPrivate,
        'by': uid,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore.runTransaction((transaction) async {
        transaction.set(userRef, {
          'lastActivity': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        final uesrPlaylistRef = userRef
            .collection('playlists')
            .doc(playlist.id);
        transaction.set(uesrPlaylistRef, playlistData);
        if (!isPrivate) {
          final publicPlaylistRef = _firestore
              .collection('playlist')
              .doc(playlist.id);
          transaction.set(publicPlaylistRef, playlistData);
        }
      });
    } catch (e) {
      print('UserActivityService Error: $e');
    }
  }

  Future<void> updatePlaylistName(
    String playlistId,
    String newName, {
    bool isPrivate = true,
  }) async {
    final uid = _userId;
    if (uid == null) return;
    try {
      final batch = _firestore.batch();

      // 1. Cập nhật trong bộ sưu tập 'playlists' của người dùng
      final userPlaylistRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('playlists')
          .doc(playlistId);

      batch.update(userPlaylistRef, {'name': newName});

      // 2. Nếu playlist là công khai, cập nhật cả ở bộ sưu tập 'playlist' chung
      if (!isPrivate) {
        final publicPlaylistRef = _firestore
            .collection('playlist')
            .doc(playlistId);
        batch.update(publicPlaylistRef, {'name': newName});
      }

      await batch.commit();
      
      // Hiển thông báo cập nhật thành công
      await NotificationService().showNotification(
        id: playlistId.hashCode,
        title: 'Playlist đã cập nhật',
        body: 'Đã đổi tên danh sách phát thành "$newName"',
      );
      
      print(
        'UserActivityService: Successfully updated playlist name to "$newName"',
      );
    } catch (e) {
      print('UserActivityService Error updating playlist name: $e');
    }
  }

  Stream<List<Playlist>> getPlaylistStream() {
    final uid = _userId;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('playlists')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return PlaylistModel.fromJson(data);
          }).toList();
        });
  }

  Future<void> addSongsToPlaylist(String playlistId, List<Song> songs) async {
    final uid = _userId;
    if (uid == null) return;
    if (songs.isEmpty) return;

    try {
      final songsRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('playlists')
          .doc(playlistId)
          .collection('songs');

      final batch = _firestore.batch();

      for (final song in songs) {
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
        batch.set(songsRef.doc(song.id), songData);
      }

      await batch.commit();
      
      // Hiển thông báo thêm bài hát thành công
      await NotificationService().showNotification(
        id: playlistId.hashCode + 1,
        title: 'Playlist đã được cập nhật',
        body: 'Đã thêm ${songs.length} bài hát vào danh sách phát.',
      );

      print(
        'UserActivityService: Successfully added ${songs.length} song(s) to playlist $playlistId',
      );
    } catch (e) {
      print('UserActivityService Error adding songs to playlist: $e');
    }
  }

  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    final uid = _userId;
    if (uid == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('playlists')
          .doc(playlistId)
          .collection('songs')
          .doc(songId)
          .delete();
          
      // Hiển thông báo xóa bài hát thành công
      await NotificationService().showNotification(
        id: playlistId.hashCode + 2,
        title: 'Playlist đã cập nhật',
        body: 'Đã xóa 1 bài hát khỏi danh sách phát.',
      );

      print(
        'UserActivityService: Successfully removed song $songId from playlist $playlistId',
      );
    } catch (e) {
      print('UserActivityService Error removing song from playlist: $e');
    }
  }

  Stream<List<Song>> getPlaylistSongsStream(String playlistId) {
    final uid = _userId;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('playlists')
        .doc(playlistId)
        .collection('songs')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return SongModel.fromJson(doc.data());
          }).toList();
        });
  }

  Future<List<Song>> getPlaylistSongs(String playlistId) async {
    final uid = _userId;
    if (uid == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('playlists')
          .doc(playlistId)
          .collection('songs')
          .get();

      return snapshot.docs.map((doc) => SongModel.fromJson(doc.data())).toList();
    } catch (e) {
      print('UserActivityService Error getting playlist songs: $e');
      return [];
    }
  }
}
