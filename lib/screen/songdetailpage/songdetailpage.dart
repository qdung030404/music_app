import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import '../../model/song.dart';
import 'audio_player_manager.dart';

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

class _SongDetailPageState extends State<SongDetailPage> with SingleTickerProviderStateMixin{
  late AnimationController _animationController;
  late AudioPlayerManager _audioPlayerManager;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 12000),
    );
    _audioPlayerManager = AudioPlayerManager(songUrl: widget.playingSong.source);
    _audioPlayerManager.init();

    }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const delta = 64;
    final raduis = (screenWidth - delta) / 2 ;

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
      child: Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.playingSong.artist,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                ),
                const SizedBox(height: 16,),
                const Text('_ ___ _'),
                const SizedBox(height: 48,),
                RotationTransition(turns: Tween(begin: 0.0, end: 1.0).animate(
                _animationController
                ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(raduis),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'asset/itunes_256.png',
                      image: widget.playingSong.image,
                      width: screenWidth  - delta,
                      height: screenWidth  - delta,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset('asset/itunes_256.png',
                          width: screenWidth  - delta,
                          height: screenWidth  - delta,
                        );
                      }
                    )
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 64, bottom: 16),
                  child: SizedBox(
                    width: 450,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(onPressed: (){}, icon: const Icon(Icons.share),
                        color: Theme.of(context).colorScheme.primary,),
                        Expanded(
                            child: Text(
                              widget.playingSong.title,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ),
                        IconButton(onPressed: (){}, icon: const Icon(Icons.favorite_outline),
                        color: Theme.of(context).colorScheme.primary,),
                      ]
                    ),
                  )
                ),
                Padding(padding: const EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 16),
                child: _progressBar(),
                ),
                Padding(padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: _mediaButton()
                ),
              ],
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    _audioPlayerManager.dispose();
    super.dispose();
  }

  StreamBuilder<DurationState> _progressBar(){
    return StreamBuilder<DurationState>(
      stream:_audioPlayerManager.durationState,
      builder: (context, snapshot){
        final durationState = snapshot.data;
        final progress = durationState?.progress ?? Duration.zero;
        final buffered = durationState?.buffered ?? Duration.zero;
        final total = durationState?.total ?? Duration.zero;
        return ProgressBar(
          progress: progress,
          buffered: buffered,
          total: total,);

      });

  }
  StreamBuilder<PlayerState> _playerState(){
    return StreamBuilder(
        stream: _audioPlayerManager.player.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          final playing = playerState?.playing;
          if (processingState == ProcessingState.loading ||
              processingState == ProcessingState.buffering) {
            return Container(
              margin: const EdgeInsets.all(8.0),
              width: 48,
              height: 48,
              child: const CircularProgressIndicator(),
            );
          }else if (playing != true) {
            return MediaButtonControl(funtion: () {_audioPlayerManager.player.play();},
              icon: Icons.play_arrow, color: null, size: 48,);
          }else if(processingState != ProcessingState.completed) {
            return MediaButtonControl(funtion: () {
              _audioPlayerManager.player.pause();},
              icon: Icons.pause, color: null, size: 48,);
          }else{
            return MediaButtonControl(funtion: (){_audioPlayerManager.player.seek(Duration.zero);},
              icon: Icons.replay, color: null, size: 48,);
          }
        },
    );
  }

  Widget _mediaButton(){
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediaButtonControl(funtion: () {  }, icon: Icons.shuffle, color: Colors.grey, size: 30,),
          MediaButtonControl(funtion: () {  }, icon: Icons.skip_previous, color: Colors.black, size: 48,),
          _playerState(),
          MediaButtonControl(funtion: () {  }, icon: Icons.skip_next, color: Colors.black, size: 48,),
          MediaButtonControl(funtion: () {  }, icon: Icons.repeat, color: Colors.grey, size: 30,),
        ]
      )
    );
  }
}
class MediaButtonControl extends StatefulWidget {
  final void Function() funtion;
  final IconData icon;
  final Color? color;
  final double? size;
  const MediaButtonControl({
    super.key,
    required this.funtion,
    required this.icon,
    required this.color,
    required this.size,
  });

  @override
  State<MediaButtonControl> createState() => _MediaButtonControlState();
}

class _MediaButtonControlState extends State<MediaButtonControl> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.funtion,
      icon: Icon(widget.icon),
      color: widget.color ?? Theme.of(context).colorScheme.primary,
      iconSize: widget.size,
    );
  }
}

