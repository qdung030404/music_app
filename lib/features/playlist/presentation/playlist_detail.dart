import 'package:flutter/material.dart';
import 'package:music_app/domain/entities/playlist_entity.dart';
import 'package:music_app/domain/entities/song_entity.dart';

import '../../managers/audio_player_manager.dart';
import '../../widget/song_list.dart';
import '../viewmodels/playlist_view_model.dart';
import '../widget/playlist_header.dart';
import '../widget/playlist_menu_bottom_sheet.dart';

class PlaylistDetail extends StatelessWidget {
  final Playlist playlist;

  const PlaylistDetail({
    super.key,
    required this.playlist,
  });

  @override
  Widget build(BuildContext context) {
    return PlaylistDetailPage(
      playlist: playlist,
    );
  }
}

class PlaylistDetailPage extends StatefulWidget {
  final Playlist playlist;

  const PlaylistDetailPage({
    super.key,
    required this.playlist,
  });

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  late PlaylistViewModel _viewModel;
  List<Song> playlistSongs = [];

  @override
  void initState() {
    super.initState();
    _viewModel = PlaylistViewModel(playlistId: widget.playlist.id);
    _observeData();
    _viewModel.loadPlaylistSongs();
  }

  void _observeData() {
    _viewModel.songsStream.listen((songs) {
      if (mounted) {
        setState(() {
          playlistSongs = songs;
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height / 2,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => PlaylistMenuBottomSheet(
                      playlist: widget.playlist,
                      songs: playlistSongs,
                      popAfterDelete: true,
                    ),
                  );
                },
                icon: const Icon(
                  Icons.more_vert,
                  size: 32,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: PlaylistHeader(
                playlist: widget.playlist,
                songs: playlistSongs,
                onPlayAll: () {
                  if (playlistSongs.isNotEmpty) {
                    AudioPlayerManager().setPlaylist(playlistSongs, 0);
                  }
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
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    SizedBox(height: 8),
                    SongList(
                      songs: playlistSongs,
                      title: 'Bài hát trong playlist',
                      playlistId: widget.playlist.id,
                    ),
                    if (playlistSongs.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text(
                            'Chưa có bài hát nào trong playlist này',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                  ],
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
