import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/domain/entities/album_entity.dart';

import '../album/presentation/album_detail.dart';

class AlbumCard extends StatelessWidget {
  const AlbumCard({
    super.key,
    required this.album,
  });
  final Album album;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlbumDetailPage(album: album),
            ),
          );
        },
        child: Container(
            width: 160, // Adjusted width for better fit
            margin: const EdgeInsets.only(right: 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      album.image,
                      height: 160,
                      width: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 160,
                        width: 160,
                        color: Colors.grey[900],
                        child: const Icon(Icons.album, color: Colors.white54),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    album.albumTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    album.artistDisplay,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ]
            )
        )
    );
  }
}
