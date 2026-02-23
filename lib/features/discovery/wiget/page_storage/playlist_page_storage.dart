
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_app/data/model/playlist.dart';
import '../../../playlist/presentation/playlist_detail.dart';

import '../../../../data/datasources/user_activity_service.dart';

class PlaylistPageStorage extends StatelessWidget {
  const PlaylistPageStorage({super.key});

  @override
  Widget build(BuildContext context) {
    final userActivityService = UserActivityService();

    return StreamBuilder<List<Playlist>>(
        key: const PageStorageKey('Playlist'),
        stream: userActivityService.getPlaylistStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
          }

          final playlists = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: playlists.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTile(
                  contentPadding: const EdgeInsets.only(bottom: 16),
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 30),
                  ),
                  title: const Text(
                    'Tạo playlist mới',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onTap: () => _showCreatePlaylistDialog(context, userActivityService),
                );
              }

              final playlist = playlists[index - 1];
              return ListTile(
                contentPadding: const EdgeInsets.only(bottom: 16),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.playlist_play, color: Colors.grey, size: 30),
                ),
                title: Text(
                  playlist.playlistName,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaylistDetail(playlist: playlist),
                    ),
                  );
                },
              );
            },
          );
        });
  }

  void _showCreatePlaylistDialog(BuildContext context, UserActivityService service) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Tạo playlist mới', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Tên playlist',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('HỦY', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                final newPlaylist = Playlist(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  playlistName: name,
                );
                await service.createPlaylist(newPlaylist);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('TẠO', style: TextStyle(color: Colors.deepPurple)),
          ),
        ],
      ),
    );
  }
}