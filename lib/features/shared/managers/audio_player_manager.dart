import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core/services/audio_device_service.dart';
import '../../../data/datasources/user_activity_service.dart';
import '../../../data/models/song.dart';

class DurationState {
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
  bool _wasPlayingBeforeDisconnect = false;

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

    // Tự động pause khi rút tai nghe hoặc ngắt kết nối Bluetooth
    _headsetSubscription = AudioDeviceService().onDeviceChanged.listen((
      outputType,
    ) {
      if (outputType == AudioOutputType.speaker &&
          AudioDeviceService().autoPauseEnabled) {
        if (player.playing) {
          _wasPlayingBeforeDisconnect = true;
          player.pause();
        }
      } else if ((outputType == AudioOutputType.wiredHeadset ||
              outputType == AudioOutputType.bluetooth) &&
          AudioDeviceService().autoContinuePlayingEnabled) {
        if (!player.playing && _wasPlayingBeforeDisconnect) {
          _wasPlayingBeforeDisconnect = false;
          player.play();
        }
      }
    });

    // Xử lý gián đoạn âm thanh (Ví dụ: Facebook bật video, Game có tiếng...)
    _interruptionSubscription = AudioDeviceService().onInterruption?.listen((
      event,
    ) {
      // Chỉ xử lý nếu tính năng đang được bật
      if (!AudioDeviceService().pauseOnInterruptionEnabled) return;

      if (event.begin) {
        if (player.playing) player.pause();
      } else {
        if (event.type != AudioInterruptionType.unknown) {
          player.play();
        }
      }
    });
  }

  static final AudioPlayerManager _instance = AudioPlayerManager._internal();

  factory AudioPlayerManager() => _instance;

  final AudioPlayer player = AudioPlayer(
    handleInterruptions: false,
    handleAudioSessionActivation: false,
  );
  late final Stream<DurationState> durationState;
  final _userActivityService = UserActivityService();
  StreamSubscription<AudioOutputType>? _headsetSubscription;
  StreamSubscription<AudioInterruptionEvent>? _interruptionSubscription;

  // Playlist Management
  List<Song> _playlist = [];
  int _currentIndex = -1;
  final _currentSongController = BehaviorSubject<Song?>();

  Stream<Song?> get currentSongStream => _currentSongController.stream;

  Song? get currentSong =>
      _currentIndex >= 0 && _currentIndex < _playlist.length
      ? _playlist[_currentIndex]
      : null;

  List<Song> get playlist => _playlist;

  // Shuffle Support
  bool _isShuffle = false;

  bool get isShuffle => _isShuffle;

  // History Management
  final List<Song> _history = [];
  final BehaviorSubject<List<Song>> _historySubject =
      BehaviorSubject<List<Song>>.seeded([]);

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

  void setPlaylist(List<Song> songs, int initialIndex) async {
    _playlist = songs;

    // Tạo nguồn âm thanh dạng danh sách
    final playlistSource = ConcatenatingAudioSource(
      children: songs
          .map(
            (song) => AudioSource.uri(
              Uri.parse(song.source),
              tag: MediaItem(
                id: song.id,
                album: song.albumName ?? "Unknown Album",
                title: song.title,
                artist: song.artistName ?? "Unknown Artist",
                artUri: Uri.parse(song.image),
              ),
            ),
          )
          .toList(),
    );

    await player.setAudioSource(playlistSource, initialIndex: initialIndex);
    player.play();
  }

  int _lastTapTime = 0;
  int _tapCount = 0;
  Timer? _tapTimer;

  void handleMediaButton() {
    if (!AudioDeviceService().mediaButtonControlEnabled) return;
    int currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime - _lastTapTime < 500) {
      // nhấn nhanh trong vòng 0.5 giây
      _tapCount++;
    } else {
      _tapCount = 1;
    }

    _lastTapTime = currentTime;
    _tapTimer?.cancel();
    _tapTimer = Timer(const Duration(milliseconds: 500), () {
      if (_tapCount == 1) {
        // Nhấn 1 lần: Play/Pause
        player.playing ? player.pause() : player.play();
      } else if (_tapCount == 2) {
        // Nhấn 2 lần: Chuyển bài kế tiếp
        skipToNext();
      } else if (_tapCount >= 3) {
        // Nhấn 3 lần: Quay lại bài trước
        skipToPrevious();
      }
      _tapCount = 0;
    });
  }

  void skipToNext() {
    if (player.hasNext) {
      player.seekToNext();
    } else {
      player.seek(Duration.zero, index: 0);
    }
  }

  void skipToPrevious() {
    if (player.hasPrevious) {
      player.seekToPrevious();
    } else {
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

  void dispose() {
    _headsetSubscription?.cancel();
    _interruptionSubscription?.cancel();
    player.dispose();
    _currentSongController.close();
    _historySubject.close();
  }
}
