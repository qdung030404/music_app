import 'package:flutter/material.dart';
import 'package:music_app/data/models/song.dart';
import 'package:music_app/features/song_detail/view/song_detail.dart';

class BuildRecommend extends StatelessWidget {
  final List<Song> songs;

  const BuildRecommend({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return const SizedBox.shrink();
    }
    final recommended = songs.take(5).toList();
    final double carouselHeight = (MediaQuery.sizeOf(context).height * 0.28).clamp(220.0, 320.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const Text(
            'Recommended',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: carouselHeight,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 16),
            scrollDirection: Axis.horizontal,
            itemCount: recommended.length,
            itemBuilder: (context, index) {
              final song = recommended[index];
              return _recommendedCard(context, song);
            },
          ),
        ),
      ],
    );
  }

  Widget _recommendedCard(BuildContext context, Song song) {
    // Dynamic width based on screen size
    final double cardWidth = (MediaQuery.sizeOf(context).width * 0.75).clamp(280.0, 400.0);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SongDetail(
              songs: songs,
              playingSong: song,
            ),
          ),
        );
      },
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(song.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              song.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              song.artistDisplay,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
