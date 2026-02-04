import 'package:flutter/material.dart';
import 'package:music_app/features/album/presentation/album_detail.dart';
import 'package:music_app/features/widget/album_card.dart';

import '../../../domain/entities/album_entity.dart';

class BuildMediaCardList extends StatelessWidget {
  final List<Album> albums;
  const BuildMediaCardList({super.key, required this.albums});

  @override
  Widget build(BuildContext context) {
    if (albums.isEmpty) {
      return const SizedBox.shrink();
    }
    final albumList = albums.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Album',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 230,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: albumList.length,
              itemBuilder: (context, index) {
                return AlbumCard(album: albumList[index]);
              }
          ),
        ),
      ],
    );
  }
}
