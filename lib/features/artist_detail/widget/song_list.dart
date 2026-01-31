import 'package:flutter/material.dart';
import 'package:music_app/features/widget/song_card.dart';

import '../../../domain/entities/song_entity.dart';

class SongList extends StatelessWidget {
  final List<Song> songs;
  final String title;
  final VoidCallback? onViewAll;
  const SongList({
    super.key,
    required this.songs,
    required this.title,
    this.onViewAll
  });

  @override
  Widget build(BuildContext context) {
    if(songs.isEmpty) return const SizedBox.shrink();
    final displaySongs = songs.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (songs.length > 5)
                TextButton(
                  onPressed: onViewAll,
                  child: const Text(
                    'Xem tất cả',
                    style: TextStyle(color: Color(0xFF7C4DFF)),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displaySongs.length,
          itemBuilder: (context, index) {
            return Theme(
              data: Theme.of(context).copyWith(
                listTileTheme: const ListTileThemeData(
                  textColor: Colors.white,
                  iconColor: Colors.white70,
                ),
              ),
              child: SongCard(
                song: displaySongs[index],
                songs: songs,
              ),
            );
          },
        ),
      ],
    );
  }
}
