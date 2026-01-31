import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/model/song.dart';
import '../../widget/song_card.dart';

class SongSuggestions extends StatefulWidget {
  final List<Song> songs;
  final VoidCallback? onPlayAll;
  const SongSuggestions({
    super.key,
    required this.songs,
    this.onPlayAll,
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        minimumSize: Size(100, 40)
                    ),
                    onPressed: widget.onPlayAll,
                    child: Text('Phát tất cả'),
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
                    icon: Icon(Icons.refresh_sharp),
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
              itemCount: 12,
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