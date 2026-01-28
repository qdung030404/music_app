import 'dart:math';

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
  late int _selectedItemIndex;
  late Song _song;
  late double _animationPosition;
  bool _isShuffle = false;
  late LoopMode _loopMode;
  @override
  void initState() {
    super.initState();
    _song = widget.playingSong;
    _animationPosition = 0.0;
    _loopMode = LoopMode.off;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 12000),
    );
    _audioPlayerManager = AudioPlayerManager();
    if(_audioPlayerManager.songUrl.compareTo(_song.source) != 0){
      _audioPlayerManager.updateSong(_song.source);
      _audioPlayerManager.prepare(isNewSong: true);
    }else{
      _audioPlayerManager.prepare();
    }
    _selectedItemIndex = widget.songs.indexOf(widget.playingSong);
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
                Text(_song.artistDisplay,
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
                      image: _song.image,
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
                              _song.title,
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
    _animationController.dispose();
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
          onSeek: _audioPlayerManager.player.seek,
          barHeight: 5,
          barCapShape: BarCapShape.round,
          baseBarColor: Colors.deepPurple[200],
          progressBarColor: Colors.deepPurple,
          thumbColor: Colors.deepPurple,
          thumbRadius: 10,
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
            _pauseAnimation();
            return Container(
              margin: const EdgeInsets.all(8.0),
              width: 48,
              height: 48,
              child: const CircularProgressIndicator(),
            );
          }else if (playing != true) {
            return MediaButtonControl(funtion: () {
              _audioPlayerManager.player.play();},
              icon: Icons.play_arrow, color: null, size: 48,);
          }else if(processingState != ProcessingState.completed) {
            _playAnimation();
            return MediaButtonControl(funtion: () {
              _pauseAnimation();
              _audioPlayerManager.player.pause();},
              icon: Icons.pause, color: null, size: 48,);
          }else{
            if(processingState == ProcessingState.completed){
              _stopAnimation();
              _resetAnimation();
            }
            return MediaButtonControl(funtion: (){
              _audioPlayerManager.player.seek(Duration.zero);
              _resetAnimation();
              _playAnimation();},
              icon: Icons.replay, color: null, size: 48,);
          }
        },
    );
  }
  void setNextSong(){
    if(_isShuffle){
      var random = Random().nextInt(widget.songs.length);
      _selectedItemIndex = random;
    }else if(_selectedItemIndex < widget.songs.length - 1){
      ++_selectedItemIndex;
    }else if(_loopMode == LoopMode.all && _selectedItemIndex == widget.songs.length - 1){
      _selectedItemIndex = 0;
    }
    if (_selectedItemIndex >= widget.songs.length) {
      _selectedItemIndex = _selectedItemIndex % widget.songs.length;
    }
    final nextItem = widget.songs[_selectedItemIndex];
    _audioPlayerManager.updateSong(nextItem.source);
    _resetAnimation();
    setState(() {
      _song = nextItem;
    });
  }
  void setPreviousSong(){
    if(_isShuffle){
      var random = Random().nextInt(widget.songs.length);
      _selectedItemIndex = random;
    }else if(_selectedItemIndex > 0){
      --_selectedItemIndex;
    }else if(_loopMode == LoopMode.all && _selectedItemIndex == 0){
      _selectedItemIndex = widget.songs.length - 1;
    }
    if (_selectedItemIndex < 0) {
      _selectedItemIndex = (-1 * _selectedItemIndex) % widget.songs.length;
    }
    final nextItem = widget.songs[_selectedItemIndex];
    _audioPlayerManager.updateSong(nextItem.source);
    _resetAnimation();
    setState(() {
      _song = nextItem;
    });
  }
  void _setRepeatOption(){
    if(_loopMode == LoopMode.off){
      _loopMode = LoopMode.one;
    }else if(_loopMode == LoopMode.one){
      _loopMode = LoopMode.all;
    }else{
      _loopMode = LoopMode.off;
    }
    setState(() {
      _audioPlayerManager.player.setLoopMode(_loopMode);
    });
  }
  IconData _repeatingIcon(){
    return switch(_loopMode){
      LoopMode.all => Icons.repeat_on,
      LoopMode.one => Icons.repeat_one,
      _ => Icons.repeat,
    };
  }
  Color? _getLoopColor(){
    return _loopMode == LoopMode.off ? Colors.grey : Colors.deepPurple;

  }
  void _playAnimation(){
    _animationController.forward(from: _animationPosition);
    _animationController.repeat();
  }
  void _pauseAnimation(){
    _animationController.stop();
    _animationPosition = _animationController.value;
  }
  void _stopAnimation(){
    _animationController.stop();

  }
  void _resetAnimation(){
    _animationController.reset();
  }
  void _setShuffle(){
    setState(() {
      _isShuffle = !_isShuffle;
    });
  }
  Color? _getShuffleColor(){
    return _isShuffle ? Colors.deepPurple : Colors.grey;
  }
  Widget _mediaButton(){
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediaButtonControl(funtion:_setShuffle, icon: Icons.shuffle, color: _getShuffleColor(), size: 30,),
          MediaButtonControl(funtion: setPreviousSong, icon: Icons.skip_previous, color: Colors.black, size: 48,),
          _playerState(),
          MediaButtonControl(funtion: setNextSong, icon: Icons.skip_next, color: Colors.black, size: 48,),
          MediaButtonControl(funtion: _setRepeatOption, icon: _repeatingIcon(), color: _getLoopColor(), size: 30,),
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

