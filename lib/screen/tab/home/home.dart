import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/screen/songdetailpage/audio_player_manager.dart';
import 'package:music_app/screen/tab/home/viewmodel.dart';

import '../../../model/song.dart';
import '../../songdetailpage/songdetailpage.dart';

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
  late MusicAppViewModel _viewModel ;

  @override
  void initState() {
    super.initState();
    _viewModel = MusicAppViewModel();
    _viewModel.loadSongs();
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
    _viewModel.songsController.close();
    AudioPlayerManager().dispose();
    
    super.dispose();
  }
  Widget getBody() {
    // if (songs.isEmpty) {
    //   return getProgressBar();
    // }

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
                return _mixCard(song);
              }
              )
        ),
      ],
    );
  }

  Widget _mixCard(Song song) {
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
  // Widget getProgressBar() {
  //   return const Center(
  //     child: CircularProgressIndicator(),
  //   );
  //
  // }
  // ListView getListView() {
  //   return ListView.separated(
  //     itemBuilder: (context, position){
  //       return getRow(position);
  //     },
  //     separatorBuilder: (context, index) {
  //       return const Divider(
  //         color: Colors.grey,
  //         thickness: 1,
  //         indent: 24,
  //         endIndent: 24,
  //       );
  //     },
  //     itemCount: songs.length,
  //     shrinkWrap: true,
  //   );
  // }
  // Widget getRow(int position) {
  //   return _SongItemSelection(parent: this, song: songs[position]);
  // }
  void observeData() {
    _viewModel.songsController.stream.listen((songList) {
      setState(() {
        songs.addAll(songList);
      });
    });
  }
  // void bottomSheet(){
  //   showModalBottomSheet(context: context, builder: (context) {
  //     return  ClipRRect(
  //       borderRadius: const BorderRadius.only(
  //         topLeft: Radius.circular(16),
  //         topRight: Radius.circular(16),
  //       ),
  //       child: Container(
  //           width: double.infinity,
  //           height: 400,
  //           color: Colors.grey,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               const Text('Bottom Sheet'),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 child: const Text('Close Bottom Sheet'),
  //               ),
  //
  //             ],
  //           )
  //
  //       ),
  //     );
  //   });
  // }
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
