import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/features/song_detail/managers/audio_player_manager.dart';
import 'package:music_app/data/model/artist.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/features/song_detail/presentation/screens/song_detail.dart';
import 'package:music_app/features/home/viewmodels/home_view_model.dart';
import 'package:music_app/features/home/widget/recommend.dart';
import 'package:music_app/features/home/widget/artist.dart';
import 'package:music_app/features/home/widget/header.dart';

import '../../../domain/entities/album_entity.dart';
import '../widget/album.dart';

class HomeTabs extends StatelessWidget {
  const HomeTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeTabPage();
  }
}

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  List<Song> songs = [];
  List<Artist> artists = [];
  List<Album> albums = [];
  late HomeViewModel _homeViewModel;

  @override
  void initState() {
    super.initState();
    _homeViewModel = HomeViewModel();
    _homeViewModel.loadAlbum();

    // Load artists
    _homeViewModel.loadArtists();
    _homeViewModel.artistsController.stream.listen((list) {
      setState(() {
        artists = list;
      });
    });

    // Load songs
    _homeViewModel.loadSongs();
    observeData();
    //
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: getBody(),
    );
  }
  @override
  void dispose() {
    _homeViewModel.dispose();
    AudioPlayerManager().dispose();

    super.dispose();
  }
  Widget getBody() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildHeader(),
            const SizedBox(height: 24),
            BuildRecommend(songs: songs,),
            const SizedBox(height: 24),
            BuildArtist(artists: artists,),
            const SizedBox(height: 24),
            BuildAlbum(albums: albums,),
            const SizedBox(height: 24),
            _buildRecentListening(),
          ],
        ),
      ),
    );
  }
  Widget _buildRecentListening() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Based on your recent listening',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: songs.length.clamp(0, 6),
          separatorBuilder: (_, __) => const Divider(indent: 24, endIndent: 24),
          itemBuilder: (_, index) {
            return _SongItemSelection(
              parent: this,
              song: songs[index],
            );
          },
        ),
      ],
    );
  }
  void observeData() {
    _homeViewModel.songsController.stream.listen((songList) {
      setState(() {
        songs.addAll(songList);
      });
    });
    _homeViewModel.albumController.stream.listen((albumList) {
      setState(() {
        albums = albumList;
      });
    });
  }
  void navigate(Song song){
    Navigator.push(context,
        CupertinoPageRoute(builder: (context){
          return SongDetail(
            songs: songs,
            playingSong: song,
          );
        })
    );
  }

}
class _SongItemSelection extends StatelessWidget {
  const _SongItemSelection({
    required this.parent,
    required this.song,

  });
  final _HomeTabPageState parent;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 24, right: 24),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FadeInImage.assetNetwork(placeholder: 'asset/itunes_256.png',
          image: song.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset('asset/itunes_256.png',
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
        parent.navigate(song);
      },
    );

  }
}
