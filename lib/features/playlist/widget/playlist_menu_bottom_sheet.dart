import 'package:flutter/material.dart';
import 'package:music_app/domain/entities/playlist_entity.dart';
import 'package:music_app/features/playlist/widget/update_playlist_page.dart';
import 'package:music_app/features/widget/download_song.dart';

import '../../../data/datasources/user_activity_service.dart';
import '../../../domain/entities/song_entity.dart';
import '../../widget/buildMenuItem.dart';
import '../presentation/song_list_page.dart';

class PlaylistMenuBottomSheet extends StatelessWidget {
  final Playlist playlist;
  final List<Song>? songs;
  final bool popAfterDelete;

  const PlaylistMenuBottomSheet({
    super.key,
    required this.playlist,
    this.songs,
    this.popAfterDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    final userActivityService = UserActivityService();
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.deepPurple, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.playlist_play, color: Colors.white),
              ),
            ),
            title: Text(
              playlist.playlistName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              'Playlist',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            child: const Divider(thickness: 2, color: Colors.grey),
          ),
          // Các tùy chọn menu
          Expanded(
            child: ListView(
              children: [
                buildMenuItem(Icons.add_circle_outline, 'Thêm bài hát', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SongListPage(playlistId: playlist.id),
                    ),
                  );
                }),
                buildMenuItem(
                  Icons.edit,
                  'Chỉnh sửa playlist',
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdatePlaylistPage(
                        service: userActivityService,
                        playlist: playlist,
                      ),
                    ),
                  ),
                ),
                if (songs != null && songs!.isNotEmpty)
                  buildMenuItem(
                    Icons.arrow_circle_down,
                    'Chọn bài hát để tải',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DownloadSong(songs: songs!),
                        ),
                      );
                    },
                  ),
                buildMenuItem(Icons.delete_outline, 'Xóa playlist', () async {
                  await userActivityService.removeItem(
                    playlist.id,
                    'playlists',
                  );
                  if (context.mounted) {
                    Navigator.pop(context);

                    if (popAfterDelete) {
                      Navigator.pop(
                        context,
                      );
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Đã xóa playlist "${playlist.playlistName}"',
                        ),
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
