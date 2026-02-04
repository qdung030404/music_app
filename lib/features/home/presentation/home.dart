import 'package:flutter/material.dart';
import 'package:music_app/data/model/artist.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/features/home/viewmodels/home_view_model.dart';
import 'package:music_app/features/home/widget/recommend.dart';
import 'package:music_app/features/home/widget/artist.dart';
import 'package:music_app/features/home/widget/header.dart';

import '../../../domain/entities/album_entity.dart';
import '../../widget/media_card_list.dart';
import '../widget/song_suggestions.dart';

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
    // Load songs
    _homeViewModel.loadSongs();
    observeData();
    //
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: getBody(),
    );
  }
  @override
  void dispose() {
    _homeViewModel.dispose();
    // Do not dispose AudioPlayerManager here as it is a singleton used globally
    // AudioPlayerManager().dispose(); 

    super.dispose();
  }
  Widget getBody() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80), // Added bottom padding to avoid overlap
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildHeader(),
            const SizedBox(height: 24),
            BuildRecommend(songs: songs,),
            const SizedBox(height: 24),
            BuildArtist(artists: artists,),
            const SizedBox(height: 24),
            if (songs.isEmpty)
              Center(child: CircularProgressIndicator())
            else
              SongSuggestions(
                songs: songs,
              ),
            const SizedBox(height: 24),
            BuildMediaCardList(albums: albums,),

          ],
        ),
      ),
    );
  }

  void observeData() {
    _homeViewModel.artistsController.stream.listen((list) {
      setState(() {
        artists = list;
      });
    });
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
}
