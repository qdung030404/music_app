

import 'dart:async';

import 'package:music_app/repository/repository.dart';

import '../../../model/song.dart';

class MusicAppViewModel{
  StreamController<List<Song>> songsController = StreamController<List<Song>>();
  void loadSongs() async {
    final repository = DefaultRepository();
    final songs = await repository.loadData();
    if (songs != null) {
      songsController.add(songs);
    }
  }
}