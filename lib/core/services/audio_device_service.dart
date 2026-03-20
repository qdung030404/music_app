import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

enum AudioOutputType {
  speaker,
  wiredHeadset,
  bluetooth,
}

class AudioDeviceService {
  static final AudioDeviceService _instance = AudioDeviceService._internal();
  factory AudioDeviceService() => _instance;
  AudioDeviceService._internal();

  static const String _keyAutoPause = 'auto_pause_on_disconnect';
  static const String _keyAutoContinuePlaying = 'auto_continue_playing_on_connect';
  static const String _keyPauseOnInterruption = 'pause_on_interruption';
  static const String _keyMediaButtonControl = 'media_button_control';
  AudioSession? _session;

  final BehaviorSubject<AudioOutputType> _deviceController =
      BehaviorSubject<AudioOutputType>.seeded(AudioOutputType.speaker);

  /// Stream phát ra [AudioOutputType] mỗi khi thiết bị âm thanh thay đổi.
  Stream<AudioOutputType> get onDeviceChanged => _deviceController.stream.distinct();

  /// Stream phát ra sự kiện gián đoạn (ví dụ: cuộc gọi đến).
  Stream<AudioInterruptionEvent>? get onInterruption => _session?.interruptionEventStream;

  AudioOutputType _currentOutput = AudioOutputType.speaker;
  AudioOutputType get currentOutput => _currentOutput;

  bool _autoPauseEnabled = true;
  bool _autoContinuePlayingEnabled = true;
  bool _pauseOnInterruptionEnabled = true;
  bool _mediaButtonControlEnabled = true;

  bool get autoPauseEnabled => _autoPauseEnabled;
  bool get autoContinuePlayingEnabled => _autoContinuePlayingEnabled;
  bool get pauseOnInterruptionEnabled => _pauseOnInterruptionEnabled;
  bool get mediaButtonControlEnabled => _mediaButtonControlEnabled;

  bool get isHeadsetOrBluetoothConnected =>
      _currentOutput == AudioOutputType.wiredHeadset ||
      _currentOutput == AudioOutputType.bluetooth;


  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _autoPauseEnabled = prefs.getBool(_keyAutoPause) ?? true;
    _autoContinuePlayingEnabled = prefs.getBool(_keyAutoContinuePlaying) ?? true;
    _pauseOnInterruptionEnabled = prefs.getBool(_keyPauseOnInterruption) ?? true;
    _mediaButtonControlEnabled = prefs.getBool(_keyMediaButtonControl) ?? true;
    _session = await AudioSession.instance;

    await _session!.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.none,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: AndroidAudioAttributes(
        usage: AndroidAudioUsage.media,
        contentType: AndroidAudioContentType.music,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
    ));

    // 1. Lắng nghe sự kiện "becoming noisy" (ví dụ: rút tai nghe)
    _session!.becomingNoisyEventStream.listen((_) {
      _currentOutput = AudioOutputType.speaker;
      _deviceController.add(_currentOutput);
    });

    // 2. Lắng nghe sự kiện thay đổi thiết bị để cập nhật UI hoặc xử lý cắm lại
    _session!.devicesChangedEventStream.listen((event) async {
      await _updateCurrentOutput();
    });

    // Kiểm tra thiết bị hiện tại ngay khi khởi động
    await _updateCurrentOutput();
  }

  /// Cập nhật trạng thái output hiện tại bằng cách quét danh sách thiết bị
  Future<void> _updateCurrentOutput() async {
    final devices = await _session!.getDevices();
    _detectFromDeviceList(devices);
    _deviceController.add(_currentOutput);
  }

  Future<void> setAutoPauseEnabled(bool value) async {
    _autoPauseEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAutoPause, value);
  }
  Future<void> setAutoContinuePlayingEnabled(bool value) async {
    _autoContinuePlayingEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAutoContinuePlaying, value);
  }

  Future<void> setPauseOnInterruptionEnabled(bool value) async {
    _pauseOnInterruptionEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPauseOnInterruption, value);
  }

  Future<void> setMediaButtonControlEnabled(bool value) async {
    _mediaButtonControlEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyMediaButtonControl, value);
  }

  /// Phát hiện thiết bị từ tập hợp hiện có khi khởi động.
  void _detectFromDeviceList(Set<AudioDevice> devices) {
    for (final device in devices) {
      final type = _mapDeviceType(device.type);
      if (type != null) {
        _currentOutput = type;
        return;
      }
    }
    _currentOutput = AudioOutputType.speaker;
  }

  /// Map [AudioDeviceType] của thư viện sang [AudioOutputType] của app.
  AudioOutputType? _mapDeviceType(AudioDeviceType type) {
    switch (type) {
      case AudioDeviceType.wiredHeadset:
      case AudioDeviceType.wiredHeadphones:
        return AudioOutputType.wiredHeadset;
      case AudioDeviceType.bluetoothA2dp: // tai nghe/loa BT chất lượng cao
      case AudioDeviceType.bluetoothSco:  // tai nghe BT dùng cho điện thoại
        return AudioOutputType.bluetooth;
      default:
        return null; // loa trong
    }
  }

  /// Giải phóng tài nguyên
  void dispose() {
    _deviceController.close();
  }
}
