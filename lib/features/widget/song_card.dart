import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/song_entity.dart';
import '../song_detail/presentation/screens/song_detail.dart';

class SongCard extends StatelessWidget {
  const SongCard({
    required this.song,
    required this.songs,
    this.width,
  });

  final Song song;
  final List<Song> songs;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 24, right: 24),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: FadeInImage.assetNetwork(
              placeholder: 'asset/itunes_256.png',
              image: song.image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'asset/itunes_256.png',
                  width: 50,
                  height: 50,
                );
              },
            ),
          ),
          title: Text(song.title,
            style: TextStyle(
              color: Colors.white
            ),
          ),
          subtitle: Text(song.artistDisplay,
            style: TextStyle(
                color: Colors.white
            ),
          ),
          trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_horiz, color: Colors.white,)
          ),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    SongDetail(
                      songs: songs,
                      playingSong: song,
                    ),
              ),
            );
          },
        )
    );
  }
}