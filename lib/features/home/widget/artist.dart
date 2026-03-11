import 'package:flutter/material.dart';

import 'package:music_app/domain/entities/artist_entity.dart';
import 'package:music_app/features/artist/presentation/artist_detail.dart';

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child:const Text(
            'Nghệ sĩ tiêu biểu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 230,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: artistList.length,
              itemBuilder: (context, index) {
                return _artistCard(context, artistList[index]);
              }
          ),
        ),
      ],
    );
  }
  Widget _artistCard(BuildContext context, Artist artist) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtistDetail(artist: artist),
          ),
        );
      },
      child: Container(
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
                color: Colors.grey[900],
                image: artist.avatar.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(artist.avatar),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: artist.avatar.isEmpty
                  ? const Center(child: Icon(Icons.person, size: 50))
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              artist.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
