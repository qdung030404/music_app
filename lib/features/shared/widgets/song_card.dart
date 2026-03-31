import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/features/shared/widgets/bottom_sheet.dart';

import 'package:music_app/data/models/song.dart';
import 'package:music_app/features/song_detail/view/song_detail.dart';

class SongCard extends StatelessWidget {
  final Song song;
  final List<Song> songs;
  final double? width;
  final String? playlistId;

  const SongCard({
    required this.song,
    required this.songs,
    this.width,
    this.playlistId,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 24, right: 24),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: song.image.isNotEmpty
              ? FadeInImage.assetNetwork(
                  placeholder: 'assets/itunes_256.png',
                  image: song.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/itunes_256.png',
                      width: 50,
                      height: 50,
                    );
                  },
                )
              : Image.asset(
                  'assets/itunes_256.png',
                  width: 50,
                  height: 50,
                ),
        ),
        title: Text(
          song.title,
        ),
        subtitle: Text(
          song.artistDisplay,
        ),
        trailing: IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SongBottomSheet(
                  song: song,
                  songs: songs,
                  playlistId: playlistId,
                );
              },
            );
          },
          icon: Icon(
            Icons.more_horiz,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => SongDetail(
                songs: songs,
                playingSong: song,
              ),
            ),
          );
        },
      ),
    );
  }
}
