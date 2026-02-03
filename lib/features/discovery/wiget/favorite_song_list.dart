import 'package:flutter/material.dart';
import 'package:music_app/data/datasources/user_activity_service.dart';

import '../../../domain/entities/song_entity.dart';
import '../../widget/song_card.dart';

class FavoriteSongList extends StatelessWidget {
  const FavoriteSongList({super.key});

  @override
  Widget build(BuildContext context) {
    final userActivityService = UserActivityService();
    return StreamBuilder<List<Song>>(
      stream: userActivityService.getFavoritesStream(),
      builder: (context, snapshot) {
        final favoriteSongs = snapshot.data ?? [];

        if (favoriteSongs.isEmpty) {
          return Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15), // Khoảng cách đẩy xuống giữa
              const Icon(Icons.music_note,
                color: Colors.grey,
                size: 160,
              ),
              const Text('bạn chưa thích bài hát nào',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16
                ),
              )
            ],
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: favoriteSongs.length,
          itemBuilder: (context, index) {
            return SongCard(
              song: favoriteSongs[index],
              songs: favoriteSongs,
            );
          },
        );
      },
    );
  }
}
