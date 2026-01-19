import 'package:flutter/material.dart';
import 'package:music_app/screen/tab/home/viewmodel.dart';

import '../../../model/song.dart';

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
    super.dispose();
  }
  Widget getBody() {
    bool ShowLoading = songs.isEmpty;
    if(ShowLoading) {
      return getProgressBar();
    }
    else {
      return getListView();
    }
  }
  Widget getProgressBar() {
    return const Center(
      child: CircularProgressIndicator(),
    );

  }
  ListView getListView() {
    return ListView.separated(
      itemBuilder: (context, position){
        return getRow(position);
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: Colors.grey,
          thickness: 1,
          indent: 24,
          endIndent: 24,
        );
      },
      itemCount: songs.length,
      shrinkWrap: true,
    );
  }
  Widget getRow(int position) {
    return _SongItemSelection(parent: this, song: songs[position]);
  }
  void observeData() {
    _viewModel.songsController.stream.listen((songList) {
      setState(() {
        songs.addAll(songList);
      });
    });
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
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset('asset/itunes_256.png',
              width: 50,
              height: 50,
            );
          },
        ),
      ),
      title: Text(song.title),
      subtitle: Text(song.artist),
      trailing: IconButton(
          onPressed: (){},
          icon: Icon(Icons.more_horiz)),
    );

  }
}
