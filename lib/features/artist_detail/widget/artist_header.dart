import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/artist_entity.dart';

class ArtistHeader extends StatelessWidget {
  final Artist artist;
  const ArtistHeader({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.5;

    return Stack(
      children: [
        // Background image
        Container(
          height: imageHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(artist.avatar),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Gradient overlay
        Container(
          height: imageHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.7),
                Colors.black,
              ],
              stops: [0.0, 0.7, 1.0],
            ),
          ),
        ),
        // Artist info
        Positioned(
          left: 16,
          right: 16,
          bottom: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                artist.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),

            ],
          ),
        ),
        // Action buttons
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: (){},
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.white70, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'QUAN TÂM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7C4DFF),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'PHÁT NHẠC',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
