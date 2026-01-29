import 'package:flutter/material.dart';

import 'package:music_app/domain/entities/song_entity.dart';

class BuildRecommend extends StatelessWidget {
  final List<Song> songs;
  const BuildRecommend({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return const SizedBox.shrink();
    }
    final recommended = songs.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommended',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
            height: 200,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recommended.length,
                itemBuilder: (context, index) {
                  final song = recommended[index];
                  return _recommendedCard(song);
                }
            )
        ),
      ],
    );
  }
  Widget _recommendedCard(Song song) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(song.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            song.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            song.artistDisplay,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
