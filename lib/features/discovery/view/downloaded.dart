import 'package:flutter/material.dart';

import '../../../core/services/download_service.dart';
import '../../../data/models/song.dart';
import '../../shared/widgets/song_list.dart';

class Downloaded extends StatefulWidget {
  const Downloaded({super.key});

  @override
  State<Downloaded> createState() => _DownloadedState();
}

class _DownloadedState extends State<Downloaded> {
  final bool _showTitle = false;
  late Future<List<Song>> _downloadedSongsFuture;

  @override
  void initState() {
    super.initState();
    _downloadedSongsFuture = DownloadService.getDownloadedSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: AnimatedOpacity(
          opacity: _showTitle ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: const Text(
            'Đã tải xuống',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: FutureBuilder<List<Song>>(
        future: _downloadedSongsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có bài hát nào được tải xuống.',
                style: TextStyle(),
              ),
            );
          }

          final songs = snapshot.data!;
          return SingleChildScrollView(
            child: SongList(
              songs: songs,
              title: 'Bài hát đã tải (${songs.length})',
            ),
          );
        },
      ),
    );
  }
}
