import 'package:flutter/material.dart';

import '../../domain/entities/album_entity.dart';

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
                return _mediaCardList(albumList[index]);
              }
          ),
        ),
      ],
    );
  }
  Widget _mediaCardList(Album album) {
    return Container(
        width: 200,
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
                      image: NetworkImage(album.image),
                      fit: BoxFit.cover,
                    ),
                  )
              ),
              const SizedBox(height: 8),
              Text(
                album.albumtitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ]
        )
    );
  }
}
