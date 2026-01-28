import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../../model/song.dart';
import 'package:http/http.dart' as http;


abstract interface class DataSource {
  Future<List<Song>?> getData();
}

class FirestoreDataSource implements DataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Song>?> getData() async {

    try {
      QuerySnapshot snapshot = await _firestore.collection('songs').get();
      print('Số documents lấy được: ${snapshot.docs.length}');
      List<Song> songs = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print('Document data: $data');
        return Song.fromJson(data);
      }).toList();
      print('Số bài hát parse được: ${songs.length}');

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

class RemoteDataSource implements DataSource {

  @override
  Future<List<Song>?> getData() async {
    const url = 'https://thantrieu.com/resources/braniumapis/songs.json';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final bodyContent = utf8.decode(response.bodyBytes);
      var wrapper = jsonDecode(bodyContent) as Map;
      var data = wrapper['songs'] as List;
      List<Song> songs = data.map((e) => Song.fromJson(e)).toList();
      return songs;
    }
    return null;
  }
}

class LocalDataSource implements DataSource {
  @override
  Future<List<Song>?> getData() async {
    final String response = await rootBundle.loadString('asset/songs.json');
    var wrapper = jsonDecode(response) as Map;
    final songList = wrapper['songs'] as List;
    List<Song> songs = songList.map((e) => Song.fromJson(e)).toList();
    return songs;
  }
}