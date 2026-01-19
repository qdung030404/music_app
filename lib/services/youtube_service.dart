import 'dart:convert';
import '../../model/song.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

abstract interface class DataSource {
  Future<List<Song>?> getData();
}

class YouTubeDataSource implements DataSource {
  static const String apiKey = 'AIzaSyBg-gUkPx3AyuliyxzKA52Tq_ih7JgCBqQ';
  static const String baseUrl = 'https://www.googleapis.com/youtube/v3';
  final _ytExplode = YoutubeExplode();

  @override
  Future<List<Song>?> getData() async {
    try {
      // Tìm kiếm video music
      final searchUrl = Uri.parse(
          '$baseUrl/search?part=snippet&q=vpop&type=video&maxResults=20&videoCategoryId=10&order=viewCount&key=$apiKey'
      );

      final searchResponse = await http.get(searchUrl);

      if (searchResponse.statusCode != 200) {
        return null;
      }

      final searchData = jsonDecode(searchResponse.body);
      final items = searchData['items'] as List;
      print('Số video tìm được: ${items.length}');
      // Lấy video IDs
      final videoIds = items
          .map((item) => item['id']['videoId'] as String)
          .join(',');

      // Lấy thông tin chi tiết của videos
      final detailsUrl = Uri.parse(
          '$baseUrl/videos?part=snippet,contentDetails&id=$videoIds&key=$apiKey'
      );

      final detailsResponse = await http.get(detailsUrl);

      if (detailsResponse.statusCode != 200) {
        return null;
      }

      final detailsData = jsonDecode(detailsResponse.body);
      final videos = detailsData['items'] as List;

      List<Song> songs = [];

      for (var video in videos) {
        final snippet = video['snippet'];
        final contentDetails = video['contentDetails'];
        final videoId = video['id'];

        songs.add(Song(
          id: videoId,
          title: snippet['title'],
          album: 'YouTube Vietnam',
          artist: snippet['channelTitle'],
          source: null,
          image: snippet['thumbnails']['high']['url'] ??
              snippet['thumbnails']['default']['url'],
          duration: _parseDuration(contentDetails['duration']),
        ));
      }

      return songs;
    } catch (e) {
      return null;
    }
  }

  // Chuyển đổi ISO 8601 duration (PT1H2M10S) sang seconds
  int _parseDuration(String isoDuration) {
    final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
    final match = regex.firstMatch(isoDuration);

    if (match == null) return 0;

    final hours = int.parse(match.group(1) ?? '0');
    final minutes = int.parse(match.group(2) ?? '0');
    final seconds = int.parse(match.group(3) ?? '0');

    return hours * 3600 + minutes * 60 + seconds;
  }
  Future<String?> _getAudioUrl(String videoId) async {
    try {
      var manifest = await _ytExplode.videos.streamsClient.getManifest(videoId);
      var audioStream = manifest.audioOnly.withHighestBitrate();
      return audioStream.url.toString();
    } catch (e) {
      return null;
    }
  }
  Future<String?> getAudioUrlForSong(String videoId) async {
    return await _getAudioUrl(videoId);
  }
}

class LocalDataSource implements DataSource {
  @override
  Future<List<Song>?> getData() {
    // TODO: implement getData
    throw UnimplementedError();
  }
}