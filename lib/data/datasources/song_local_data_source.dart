import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../data/model/song.dart';

/// Local assets JSON data source for songs.
class SongLocalDataSource {
  Future<List<Song>?> getData() async {
    final String response = await rootBundle.loadString('assets/songs.json');
    final Map<String, dynamic> wrapper = jsonDecode(response);
    final Map<String, dynamic> songMap = wrapper['songs'];
    final List<Song> songs = songMap.entries.map((entry) {
      final data = Map<String, dynamic>.from(entry.value);
      data['id'] = entry.key;
      return SongModel.fromJson(data);
    }).toList();
    return songs;
  }
}

