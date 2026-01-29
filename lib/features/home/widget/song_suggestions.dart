import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/model/song.dart';
import '../../song_detail/presentation/screens/song_detail.dart';
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
                return _SongItemSelection(
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

class _SongItemSelection extends StatelessWidget {
  const _SongItemSelection({
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
          title: Text(song.title),
          subtitle: Text(song.artistDisplay),
          trailing: IconButton(
              onPressed: (){},
              icon: Icon(Icons.more_horiz)
          ),
          onTap: (){
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
        )
    );
  }
}