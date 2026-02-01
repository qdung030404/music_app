import 'package:flutter/material.dart';
import 'package:music_app/domain/entities/album_entity.dart';
import 'package:music_app/domain/entities/song_entity.dart';
import 'package:music_app/features/artist_detail/widget/song_list.dart';
import 'package:music_app/features/widget/song_card.dart';

import '../viewmodels/song_view_model.dart';
import '../widget/header.dart';

class AlbumDetail extends StatelessWidget {
  final Album album;
  const AlbumDetail({
    super.key,
    required this.album,
  });

  @override
  Widget build(BuildContext context) {
    return AlbumDetailPage(
      album: album,);
  }
}
class AlbumDetailPage extends StatefulWidget {
  final Album album;
  const AlbumDetailPage({
    super.key,
    required this.album
  });

  @override
  State<AlbumDetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<AlbumDetailPage> {
  late SongViewModel _viewModel;
  List<Song> albumSongs = [];


  @override
  void initState() {
    super.initState();
    _viewModel = SongViewModel(albumId: widget.album.id);
    _observeData();
    _viewModel.loadAlbumSongs();
    
  }

  void _observeData() {
    _viewModel.songsStream.listen((songs) {
      if (mounted) {
        setState(() {
          albumSongs = songs;
        });
      }
    });
  }
  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 520,
            pinned: true,
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Header(
                album: widget.album,
                onPlayShuffle: () {
                  // Logic to play shuffle if needed
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<bool>(
              stream: _viewModel.isLoadingStream,
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(color: Colors.deepPurple),
                    ),
                  );
                }
                return SongList(
                  songs: albumSongs,
                  title: 'Bài hát',
                );
              },
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 100), // Space for mini player
          ),
        ],
      ),
    );
  }
}

