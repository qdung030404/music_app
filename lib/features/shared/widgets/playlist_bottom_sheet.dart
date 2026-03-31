import 'package:flutter/material.dart';

import 'package:music_app/data/datasources/user_activity_service.dart';
import 'package:music_app/data/models/song.dart';
import 'package:music_app/features/discovery/widget/page_storage/playlist_page_storage.dart';

class PlaylistBottomSheet extends StatefulWidget {
  final List<Song> songs;

  const PlaylistBottomSheet({super.key, required this.songs});

  @override
  State<PlaylistBottomSheet> createState() => _PlaylistBottomSheetState();
}

class _PlaylistBottomSheetState extends State<PlaylistBottomSheet> {
  final UserActivityService _userActivityService = UserActivityService();

  Future<void> _addSongsToPlaylist(
    String playlistId,
    String playlistName,
  ) async {
    await _userActivityService.addSongsToPlaylist(playlistId, widget.songs);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đã thêm ${widget.songs.length} bài hát vào playlist $playlistName',
          ),
          backgroundColor: Colors.deepPurple,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Chọn Playlist',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(color: Colors.grey),
          Expanded(
            child: PlaylistPageStorage(
              onPlaylistTap: (playlist) =>
                  _addSongsToPlaylist(playlist.id, playlist.playlistName),
            ),
          ),
        ],
      ),
    );
  }
}
