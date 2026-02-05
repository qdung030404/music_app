
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../data/datasources/user_activity_service.dart';
import '../../../../domain/entities/album_entity.dart';
import '../../../album/presentation/album_detail.dart';

class AlbumPageStorage extends StatelessWidget {
  const AlbumPageStorage({super.key});

  @override
  Widget build(BuildContext context) {
    final userActivityService = UserActivityService();

    // Currently both tabs show albums until Playlist logic is implemented
    return StreamBuilder<List<Album>>(
        key: PageStorageKey('Album'),
        stream: userActivityService.getAlbumStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
          }

          final favoriteAlbums = snapshot.data ?? [];

          if (favoriteAlbums.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.solidFolderOpen,
                    color: Colors.grey,
                    size: 80,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bạn chưa thích album nào',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  )
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteAlbums.length,
            itemBuilder: (context, index) {
              final album = favoriteAlbums[index];
              return ListTile(
                contentPadding: const EdgeInsets.only(bottom: 16),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    album.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[900],
                      child: const Icon(Icons.album, color: Colors.white54),
                    ),
                  ),
                ),
                title: Text(
                  album.albumTitle,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  album.artistDisplay,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlbumDetailPage(album: album),
                    ),
                  );
                },
              );
            },
          );
        });
  }
}