import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/song.dart';

class SongDetail extends StatelessWidget {
  const SongDetail({super.key, required this.songs, required this.playingSong});
  final List<Song> songs;
  final Song playingSong;


  @override
  Widget build(BuildContext context) {
    return SongDetailPage(
      songs: songs,
      playingSong: playingSong,
    );
  }
}

class SongDetailPage extends StatefulWidget {
  const SongDetailPage({super.key, required this.songs, required this.playingSong});
  final List<Song> songs;
  final Song playingSong;
  @override
  State<SongDetailPage> createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage> {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Center(
    //     child: Text('PlayingSong'),
    //   ),
    // );
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle:const Text('Playing Song'),
        trailing: IconButton(onPressed: (){}, icon: const Icon(Icons.more_horiz)),
      ),
      child: Center(
        child: const Text('PlayingSong'),
      ),
    );
  }
}
