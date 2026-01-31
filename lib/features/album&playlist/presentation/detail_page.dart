import 'package:flutter/material.dart';
import 'package:music_app/domain/entities/song_entity.dart';
import 'package:music_app/features/artist_detail/widget/song_list.dart';
import 'package:music_app/features/widget/song_card.dart';

import '../widget/header.dart';

class Detail extends StatelessWidget {
  final List<Song> songs;
  final String title;
  const Detail({
    super.key,
    required this.songs,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return DetailPage(
      songs: songs,
      title: title,);
  }
}
class DetailPage extends StatefulWidget {
  final List<Song> songs;
  final String title;
  const DetailPage({
    super.key,
    required this.songs,
    required this.title
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _showAllSongs = false;

  void _toggleShowAll() {
    setState(() {
      _showAllSongs = !_showAllSongs;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.more_horiz, color: Colors.white))
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Center(
                 child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Header(),
                      SizedBox(height: 16),
                      _showAllSongs
                          ? _buildFullSongList()
                          : SongList(
                        songs: widget.songs,
                        title: widget.title,
                        onViewAll: _toggleShowAll,
                      ),
                    ],
                  )
              )
          )
      ),
    );
  }
  Widget _buildFullSongList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            OutlinedButton(
              onPressed: _toggleShowAll,
              child: const Text('Thu gọn'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.songs.length,
          itemBuilder: (context, index) {
            return SongCard(
              song: widget.songs[index],
              songs: widget.songs,
            );
          },
        ),
      ],
    );
  }
}

