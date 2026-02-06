import 'package:flutter/material.dart';
import '../../../data/model/song.dart';
import '../../widget/song_card.dart';
import '../../managers/audio_player_manager.dart';

class SongSuggestions extends StatefulWidget {
  final List<Song> songs;
  const SongSuggestions({
    super.key,
    required this.songs,
  });

  @override
  State<SongSuggestions> createState() => _SongSuggestionsState();
}

class _SongSuggestionsState extends State<SongSuggestions> {
  late List<Song> displayedSongs;
  @override
  void initState() {
    super.initState();
    _shuffleSongs();
  }

  void _shuffleSongs() {
    setState(() {
      displayedSongs = List.from(widget.songs)..shuffle();
    });
  }

  void _playAll() {
    if (displayedSongs.isNotEmpty) {
      AudioPlayerManager().setPlaylist(displayedSongs, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    double itemWidth = MediaQuery.of(context).size.width;
    double itemHeight = (250 - 16) / 3;
    double scale = itemHeight / itemWidth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gợi ý bài hát',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
            Row(
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.grey, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: _playAll,
                    icon: Icon(Icons.play_arrow, color: Colors.white,),
                    label: Text('Phát tất cả',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    style: IconButton.styleFrom(
                      side: BorderSide(color: Colors.grey, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: _shuffleSongs,
                    icon: Icon(Icons.refresh_sharp, color: Colors.white,),
                  ),
                ]
            )
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 250,
          child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: scale,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: displayedSongs.length > 12 ? 12 : displayedSongs.length,
              itemBuilder: (context, index) {
                return SongCard(
                  song: displayedSongs[index],
                  songs: displayedSongs,
                  width: itemWidth,
                );
              }
          ),
        ),
      ],
    );
  }

}