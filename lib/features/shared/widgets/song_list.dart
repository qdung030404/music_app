import 'package:flutter/material.dart';
import 'package:music_app/features/shared/widgets/song_card.dart';

import 'package:music_app/data/models/song.dart';

class SongList extends StatelessWidget {
  final List<Song> songs;
  final String title;
  final VoidCallback? onViewAll;
  final String? playlistId;

  const SongList({
    super.key,
    required this.songs,
    required this.title,
    this.onViewAll,
    this.playlistId,
  });

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) return const SizedBox.shrink();
    final displaySongs = songs.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
            return SongCard(
              song: displaySongs[index],
              songs: songs,
              playlistId: playlistId,
            );
          },
        ),
      ],
    );
  }
}
