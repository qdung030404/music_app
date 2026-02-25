import 'package:flutter/material.dart';
import '../../data/datasources/user_activity_service.dart';
import '../../domain/entities/song_entity.dart';
import '../discovery/wiget/page_storage/playlist_page_storage.dart';

class PlaylistBottomSheet extends StatefulWidget {
  final Song song;
  const PlaylistBottomSheet({super.key, required this.song});

  @override
  State<PlaylistBottomSheet> createState() => _PlaylistBottomSheetState();
}

class _PlaylistBottomSheetState extends State<PlaylistBottomSheet> {
  final UserActivityService _userActivityService = UserActivityService();

  Future<void> _addSongToPlaylist(String playlistId, String playlistName) async {
    await _userActivityService.addSongToPlaylist(playlistId, widget.song);
    if (mounted) {
      Navigator.pop(context); // Close the playlist bottom sheet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã thêm bài hát vào playlist $playlistName'),
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
        color: Colors.grey[900],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Chọn Playlist',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(color: Colors.grey),
          Expanded(
            child: PlaylistPageStorage(
              onPlaylistTap: (playlist) => _addSongToPlaylist(playlist.id, playlist.playlistName),
            ),
          ),
        ],
      ),
    );
  }
}
