import 'dart:convert';
import 'package:flutter/services.dart';

import '../../model/song.dart';
import 'package:http/http.dart' as http;


abstract interface class DataSource {
  Future<List<Song>?> getData();
}

class RemoteDataSource implements DataSource {

  @override
  Future<List<Song>?> getData() async{
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
    throw UnimplementedError();
  }

}

class LocalDataSource implements DataSource {
  @override
  Future<List<Song>?> getData() async{
    final String response = await rootBundle.loadString('asset/songs.json');
    var wrapper = jsonDecode(response) as Map;
    final songList = wrapper['songs'] as List;
    List<Song> songs = songList.map((e) => Song.fromJson(e)).toList();
    return songs;
  }
}