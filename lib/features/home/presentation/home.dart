import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/features/song_detail/managers/audio_player_manager.dart';
import 'package:music_app/data/model/artist.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/features/song_detail/presentation/screens/song_detail.dart';
import 'package:music_app/features/home/viewmodels/home_view_model.dart';

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
  late HomeViewModel _homeViewModel;

  @override
  void initState() {
    super.initState();
    _homeViewModel = HomeViewModel();

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
            _buildHeader(),
            const SizedBox(height: 24),
            _buildRecommended(),
            const SizedBox(height: 24),
            _buildArtist(),
            const SizedBox(height: 24),
            _buildRecentListening(),
          ],
        ),
      ),
    );
  }
  Widget _buildHeader() {
    final user = FirebaseAuth.instance.currentUser;
    return Row(
      children: [
         CircleAvatar(
          radius: 20,
          backgroundImage: user?.photoURL != null
              ? NetworkImage(user!.photoURL!)
              : null,
          child: user?.photoURL == null
              ? const Icon(Icons.person, size: 22)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back !',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                user?.displayName ??
                    user?.email?.split('@')[0] ??
                    'User',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,)
              ),
            ],
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.bar_chart)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
      ],
    );
  }

  Widget _buildRecommended() {
    if (songs.isEmpty) {
      return const SizedBox.shrink();
    }
    final recommended = songs.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommended',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommended.length,
              itemBuilder: (context, index) {
                final song = recommended[index];
                return _recommendedCard(song);
              }
              )
        ),
      ],
    );
  }

  Widget _recommendedCard(Song song) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(song.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            song.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            song.artistDisplay,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
  Widget _buildArtist() {
    if (artists.isEmpty) {
      return const SizedBox.shrink();
    }
    final artistList = artists.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Artist',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: artistList.length,
              itemBuilder: (context, index) {
                return _artistCard(artistList[index]);
              }
          ),
        ),
      ],
    );

  }

  Widget _artistCard(Artist artist){
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              image: DecorationImage(
                image: NetworkImage(artist.avatar),
                fit: BoxFit.cover,
              ),
            )
          ),
          const SizedBox(height: 8),
          Text(
            artist.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ]
      )
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
