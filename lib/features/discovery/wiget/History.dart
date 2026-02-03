import 'package:flutter/material.dart';
import 'package:music_app/domain/entities/song_entity.dart';
import 'package:music_app/data/datasources/user_activity_service.dart';

import '../../widget/song_card.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    final userActivityService = UserActivityService();
    double itemWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<List<Song>>(
      stream: userActivityService.getHistoryStream(),
      builder: (context, snapshot) {
        final historySongs = snapshot.data ?? [];

        if (historySongs.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Nghe gần đây',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: historySongs.length,
                itemBuilder: (context, index) {
                  return SongCard(
                    song: historySongs[index],
                    songs: historySongs,
                    width: itemWidth,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}