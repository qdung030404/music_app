import 'package:flutter/material.dart';
import 'package:music_app/features/shared/widgets/album_card.dart';

import '../../../data/models/album.dart';

class BuildMediaCardList extends StatelessWidget {
  final List<Album> albums;

  const BuildMediaCardList({super.key, required this.albums});

  @override
  Widget build(BuildContext context) {
    if (albums.isEmpty) {
      return const SizedBox.shrink();
    }
    final albumList = albums.take(5).toList();
    final double carouselHeight = (MediaQuery.sizeOf(context).height * 0.28).clamp(220.0, 320.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const Text(
            'Album',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: carouselHeight,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 16),
            scrollDirection: Axis.horizontal,
            itemCount: albumList.length,
            itemBuilder: (context, index) {
              return AlbumCard(album: albumList[index]);
            },
          ),
        ),
      ],
    );
  }
}
