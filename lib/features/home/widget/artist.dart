import 'package:flutter/material.dart';

import 'package:music_app/domain/entities/artist_entity.dart';

class BuildArtist extends StatelessWidget {
  final List<Artist> artists;
  const BuildArtist({super.key, required this.artists});

  @override
  Widget build(BuildContext context) {
    if (artists.isEmpty) {
      return const SizedBox.shrink();
    }
    final artistList = artists.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Artist',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: artistList.length,
              itemBuilder: (context, index) {
                return _artistCard(artistList[index]);
              }
          ),
        ),
      ],
    );
  }
  Widget _artistCard(Artist artist) {
    return Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image: DecorationImage(
                      image: NetworkImage(artist.avatar),
                      fit: BoxFit.cover,
                    ),
                  )
              ),
              const SizedBox(height: 8),
              Text(
                artist.name,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ]
        )
    );
  }
}
