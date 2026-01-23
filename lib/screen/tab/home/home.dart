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
    bool showLoading = songs.isEmpty;
    if(showLoading) {
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
  void bottomSheet(){
    showModalBottomSheet(context: context, builder: (context) {
      return  ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: Container(
          width: double.infinity,
          height: 400,
          color: Colors.grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Bottom Sheet'),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close Bottom Sheet'),
              ),

            ],
          )

        ),
      );
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
      subtitle: Text(song.artist),
      trailing: IconButton(
          onPressed: (){parent.bottomSheet();},
          icon: Icon(Icons.more_horiz)
      ),
      onTap: (){
        parent.navigate(song);
      },
    );

  }
}
