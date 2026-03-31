import 'package:flutter/material.dart';
import 'package:music_app/data/models/album.dart';
import 'package:music_app/features/album/view/add_album_song_to_playlist.dart';
import 'package:music_app/features/shared/widgets/download_song.dart';

import '../../../data/datasources/user_activity_service.dart';
import '../../../data/models/song.dart';
import '../../shared/widgets/buildMenuItem.dart';

class AlbumMenuBottomSheet extends StatelessWidget {
  final Album album;
  final List<Song>? songs;

  const AlbumMenuBottomSheet({
    super.key,
    required this.album,
    this.songs,
  });

  @override
  Widget build(BuildContext context) {
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
                  borderRadius: BorderRadius.circular(8),
                ),
                child: album.image.isNotEmpty
                    ? FadeInImage.assetNetwork(
                        placeholder: 'assets/itunes_256.png',
                        image: album.image,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/itunes_256.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            title: Text(
              album.albumTitle,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              album.artistDisplay,
              style: const TextStyle(color: Colors.grey),
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
                buildMenuItem(Icons.search, 'Tìm kiếm bài hát', () {}),
                buildMenuItem(Icons.edit, 'Thêm vào playlist', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddAlbumSongToPlaylist(
                        albumId: album.id,
                      ),
                    ),
                  );
                }),
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
                buildMenuItem(Icons.delete_outline, 'chia sẻ', () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
