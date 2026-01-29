import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../data/model/song.dart';

/// Local asset JSON data source for songs.
class SongLocalDataSource {
  Future<List<Song>?> getData() async {
    final String response = await rootBundle.loadString('asset/songs.json');
    final wrapper = jsonDecode(response) as Map;
    final songList = wrapper['songs'] as List;
    final songs = songList.map((e) => SongModel.fromJson(e)).toList();
    return songs;
  }
}

