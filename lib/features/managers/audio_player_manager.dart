import 'package:rxdart/rxdart.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math';
import '../../../../data/model/song.dart';
import '../../../../domain/entities/song_entity.dart';
import '../../../data/datasources/user_activity_service.dart';

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
  AudioPlayerManager._internal() {
    durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
      player.positionStream,
      player.playbackEventStream,
      (position, playbackEvent) => DurationState(
        progress: position,
        buffered: playbackEvent.bufferedPosition,
        total: playbackEvent.duration,
      ),
    ).asBroadcastStream();

    // Auto-skip to next song when current one finishes
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        skipToNext();
      }
    });
  }
  static final AudioPlayerManager _instance = AudioPlayerManager._internal();
  factory AudioPlayerManager() => _instance;

  final AudioPlayer player = AudioPlayer();
  late final Stream<DurationState> durationState;
  final _userActivityService = UserActivityService();
  
  // Playlist Management
  List<Song> _playlist = [];
  int _currentIndex = -1;
  final _currentSongController = BehaviorSubject<Song?>();
  Stream<Song?> get currentSongStream => _currentSongController.stream;
  Song? get currentSong => _currentIndex >= 0 && _currentIndex < _playlist.length
      ? _playlist[_currentIndex]
      : null;
  List<Song> get playlist => _playlist;

  // Shuffle Support
  bool _isShuffle = false;
  bool get isShuffle => _isShuffle;

  // Legacy URL support (internal use mostly now)
  String songUrl = ''; 

  // History Management
  final List<Song> _history = [];
  final BehaviorSubject<List<Song>> _historySubject = BehaviorSubject<List<Song>>.seeded([]);
  Stream<List<Song>> get historyStream => _historySubject.stream;
  List<Song> get history => _history;

  void prepare({bool isNewSong = false}){
    if(isNewSong && songUrl.isNotEmpty){
      print('DEBUG: Preparing new song: $songUrl');
      player.setUrl(songUrl);
      player.play();

      // Add to history
      if (currentSong != null) {
        print('DEBUG: Adding ${currentSong!.title} to history');
        _addToHistory(currentSong!);
      } else {
        print('DEBUG: currentSong is null, cannot add to history');
      }
    }
  }

  void _addToHistory(Song song) {
    // Avoid duplicates in history, move latest to front
    _history.removeWhere((item) => item.id == song.id);
    _history.insert(0, song);

    // Keep only last 5
    if (_history.length > 5) {
      _history.removeLast();
    }
    _historySubject.add(List.from(_history));

    // Save to Firestore
    _userActivityService.addToHistory(song);
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
    _currentSongController.add(song);
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
    _currentSongController.close();
  }
}