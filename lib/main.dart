import 'package:flutter/material.dart';
import 'package:music_app/repository/repository.dart';
import 'package:music_app/services/youtube_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Test 1: YouTubeDataSource trực tiếp
  debugPrint('=== TEST YOUTUBE DATA SOURCE ===');
  final youtubeSource = YouTubeDataSource();
  final songs = await youtubeSource.getData();

  if (songs != null) {
    debugPrint('✓ Lấy được ${songs.length} bài hát');
    for (var song in songs) {
      debugPrint('---');
      debugPrint('ID: ${song.id}');
      debugPrint('Title: ${song.title}');
      debugPrint('Artist: ${song.artist}');
      debugPrint('Album: ${song.album}');
      debugPrint('Duration: ${song.duration}s');
      debugPrint('Source: ${song.source}');
      debugPrint('Image: ${song.image}');
    }
  } else {
    debugPrint('✗ Không lấy được dữ liệu từ YouTube');
  }

  // Test 2: Repository
  debugPrint('\n=== TEST REPOSITORY ===');
  final repository = DefaultRepository();
  final repoSongs = await repository.getData();

  if (repoSongs != null && repoSongs.isNotEmpty) {
    debugPrint('✓ Repository trả về ${repoSongs.length} bài hát');
    debugPrint('Bài đầu tiên: ${repoSongs.first.title}');
  } else {
    debugPrint('✗ Repository trả về danh sách rỗng');
  }

  runApp(const MusicApp());
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Music App Test')),
        body: const Center(child: Text('Check debug console')),
      ),
    );
  }
}