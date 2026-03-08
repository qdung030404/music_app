import 'package:flutter/material.dart';
import '../../../core/services/download_service.dart';
import '../../../domain/entities/song_entity.dart';
import '../../widget/song_list.dart';


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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF06A0B5), Colors.black],
            stops: [0.01, 0.15]
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: _showTitle ? Colors.black.withOpacity(0.8) : Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: AnimatedOpacity(
            opacity: _showTitle ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: const Text(
              'Đã tải xuống',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_horiz, color: Colors.white),
            ),
          ],
        ),
        body: FutureBuilder<List<Song>>(
          future: _downloadedSongsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Chưa có bài hát nào được tải xuống.', style: TextStyle(color: Colors.white70)),
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
      ),
    );
  }
}
