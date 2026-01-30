import 'package:rxdart/rxdart.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math';
import '../../../../data/model/song.dart';
import '../../../../domain/entities/song_entity.dart';

class DurationState{
  const DurationState({
    required this.progress,
    required this.buffered,
    this.total,
  });
  final Duration progress;
  final Duration buffered;
  final Duration? total;
}

class AudioPlayerManager {
  AudioPlayerManager._internal();
  static final AudioPlayerManager _instance = AudioPlayerManager._internal();
  factory AudioPlayerManager() => _instance;

  final player = AudioPlayer();
  Stream<DurationState>? durationState;
  
  // Playlist Management
  List<Song> _playlist = [];
  int _currentIndex = -1;
  final BehaviorSubject<Song?> _currentSongSubject = BehaviorSubject<Song?>.seeded(null);
  Stream<Song?> get currentSongStream => _currentSongSubject.stream;
  Song? get currentSong => _currentSongSubject.value;
  List<Song> get playlist => _playlist;

  // Shuffle Support
  bool _isShuffle = false;
  bool get isShuffle => _isShuffle;

  // Legacy URL support (internal use mostly now)
  String songUrl = ''; 

  void prepare({bool isNewSong = false}){
    durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
      player.positionStream,
      player.playbackEventStream,
      (position, playbackEvent) => DurationState(
        progress: position,
        buffered: playbackEvent.bufferedPosition,
        total: playbackEvent.duration,
      ),
    );
    if(isNewSong && songUrl.isNotEmpty){
      player.setUrl(songUrl);
      player.play();
    }
  }

  void updateSong(String url){
    songUrl = url;
    prepare(); 
  }
  
  // New methods for Playlist Management
  void setPlaylist(List<Song> songs, int initialIndex) {
    _playlist = songs;
    _currentIndex = initialIndex;
    if (_currentIndex >= 0 && _currentIndex < _playlist.length) {
      _playCurrentSong();
    }
  }

  void _playCurrentSong() {
    if (_playlist.isEmpty || _currentIndex < 0 || _currentIndex >= _playlist.length) return;
    
    final song = _playlist[_currentIndex];
    _currentSongSubject.add(song);
    songUrl = song.source;
    
    // Auto-play when song changes
    prepare(isNewSong: true); 
  }

  void skipToNext() {
    if (_playlist.isEmpty) return;
    
    if (_isShuffle) {
      _currentIndex = Random().nextInt(_playlist.length);
    } else {
       if (_currentIndex < _playlist.length - 1) {
        _currentIndex++;
      } else {
        // Loop back to start.
        _currentIndex = 0;
      }
    }
   
    _playCurrentSong();
  }

  void skipToPrevious() {
    if (_playlist.isEmpty) return;
    
    if (_isShuffle) {
      _currentIndex = Random().nextInt(_playlist.length);
    } else {
      if (_currentIndex > 0) {
        _currentIndex--;
      } else {
        _currentIndex = _playlist.length - 1;
      }
    }
    _playCurrentSong();
  }

  void setShuffle(bool enable) {
    _isShuffle = enable;
  }

  void setLoopMode(LoopMode mode) {
    player.setLoopMode(mode);
  }
  
  void dispose(){
    player.dispose();
    _currentSongSubject.close();
  }
}