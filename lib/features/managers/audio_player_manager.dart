import 'package:rxdart/rxdart.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math';
import '../../../../data/model/song.dart';
import '../../../../domain/entities/song_entity.dart';
import '../../../data/datasources/user_activity_service.dart';
import 'package:just_audio_background/just_audio_background.dart';

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

    // Lắng nghe sự thay đổi bài hát từ player để cập nhật UI và lịch sử
    player.currentIndexStream.listen((index) {
      if (index != null && _playlist.isNotEmpty && index < _playlist.length) {
        _currentIndex = index;
        final song = _playlist[index];
        _currentSongController.add(song);
        _addToHistory(song);
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

  // History Management
  final List<Song> _history = [];
  final BehaviorSubject<List<Song>> _historySubject = BehaviorSubject<List<Song>>.seeded([]);
  Stream<List<Song>> get historyStream => _historySubject.stream;
  List<Song> get history => _history;

  void _addToHistory(Song song) {
    // Tránh trùng lặp trong lịch sử
    if (_history.isNotEmpty && _history.first.id == song.id) return;
    
    _history.removeWhere((item) => item.id == song.id);
    _history.insert(0, song);

    if (_history.length > 5) {
      _history.removeLast();
    }
    _historySubject.add(List.from(_history));
    _userActivityService.addToHistory(song);
  }
  
  // Playlist Management mới dùng ConcatenatingAudioSource
  void setPlaylist(List<Song> songs, int initialIndex) async {
    _playlist = songs;
    
    // Tạo nguồn âm thanh dạng danh sách
    final playlistSource = ConcatenatingAudioSource(
      children: songs.map((song) => AudioSource.uri(
        Uri.parse(song.source),
        tag: MediaItem(
          id: song.id,
          album: song.albumName ?? "Unknown Album",
          title: song.title,
          artist: song.artistName ?? "Unknown Artist",
          artUri: Uri.parse(song.image),
        ),
      )).toList(),
    );

    await player.setAudioSource(playlistSource, initialIndex: initialIndex);
    player.play();
  }

  void skipToNext() {
    if (player.hasNext) {
      player.seekToNext();
    } else {
      // Loop back to start if at the end
      player.seek(Duration.zero, index: 0);
    }
  }

  void skipToPrevious() {
    if (player.hasPrevious) {
      player.seekToPrevious();
    } else {
      // Jump to last song if at the start
      player.seek(Duration.zero, index: _playlist.length - 1);
    }
  }

  void setShuffle(bool enable) {
    _isShuffle = enable;
    player.setShuffleModeEnabled(enable);
  }

  void setLoopMode(LoopMode mode) {
    player.setLoopMode(mode);
  }

  void dispose(){
    player.dispose();
    _currentSongController.close();
    _historySubject.close();
  }
}
