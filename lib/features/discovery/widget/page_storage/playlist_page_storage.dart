import 'package:flutter/material.dart';
import 'package:music_app/data/models/playlist.dart';
import 'package:music_app/features/playlist/widget/playlist_menu_bottom_sheet.dart';

import '../../../../data/datasources/user_activity_service.dart';
import '../../../playlist/view/playlist_detail.dart';
import 'create_playlist_page.dart';

class PlaylistPageStorage extends StatelessWidget {
  final Function(Playlist)? onPlaylistTap;

  const PlaylistPageStorage({super.key, this.onPlaylistTap});

  @override
  Widget build(BuildContext context) {
    final userActivityService = UserActivityService();

    return StreamBuilder<List<Playlist>>(
      key: const PageStorageKey('Playlist'),
      stream: userActivityService.getPlaylistStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.deepPurple),
          );
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
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, size: 30),
                ),
                title: const Text(
                  'Tạo playlist mới',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreatePlaylistPage(
                        service: userActivityService,
                      ),
                    ),
                  );
                },
              );
            }

            final playlist = playlists[index - 1];
            return GestureDetector(
              onLongPress: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) =>
                      PlaylistMenuBottomSheet(playlist: playlist),
                );
              },
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.playlist_play, size: 30),
                ),
                title: Text(
                  playlist.playlistName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                onTap: () {
                  if (onPlaylistTap != null) {
                    onPlaylistTap!(playlist);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PlaylistDetail(playlist: playlist),
                      ),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
