import 'dart:async';
import 'package:audio_session/audio_session.dart';

/// Loại thiết bị âm thanh đang kết nối
enum AudioOutputType {
  /// Đang dùng loa trong của điện thoại
  speaker,

  /// Đang cắm tai nghe có dây (wired headphones/earphones)
  wiredHeadset,

  /// Đang kết nối Bluetooth (tai nghe/loa BT)
  bluetooth,
}

/// Service để theo dõi trạng thái kết nối thiết bị âm thanh.
/// Sử dụng package `audio_session` để lắng nghe các sự kiện.
class AudioDeviceService {
  static final AudioDeviceService _instance = AudioDeviceService._internal();
  factory AudioDeviceService() => _instance;
  AudioDeviceService._internal();

  AudioSession? _session;
  final StreamController<AudioOutputType> _deviceController =
      StreamController<AudioOutputType>.broadcast();

  /// Stream phát ra [AudioOutputType] mỗi khi thiết bị âm thanh thay đổi.
  Stream<AudioOutputType> get onDeviceChanged => _deviceController.stream;

  AudioOutputType _currentOutput = AudioOutputType.speaker;

  /// Loại thiết bị âm thanh hiện tại.
  AudioOutputType get currentOutput => _currentOutput;

  /// Trả về `true` nếu đang kết nối tai nghe hoặc loa Bluetooth (không phải loa trong).
  bool get isHeadsetOrBluetoothConnected =>
      _currentOutput == AudioOutputType.wiredHeadset ||
      _currentOutput == AudioOutputType.bluetooth;

  /// Khởi tạo service. Gọi một lần trong `main()` hoặc tại widget gốc.
  Future<void> init() async {
    _session = await AudioSession.instance;

    // Cấu hình session cho ứng dụng nhạc
    await _session!.configure(const AudioSessionConfiguration.music());

    // Lắng nghe sự kiện "headset plugged/unplugged"
    // devicesAdded và devicesRemoved là Set<AudioDevice>
    _session!.devicesChangedEventStream.listen((event) {
      _updateOutputType(event.devicesAdded, event.devicesRemoved);
    });

    // Kiểm tra thiết bị hiện tại ngay khi khởi động
    // getDevices() trả về Set<AudioDevice>
    final devices = await _session!.getDevices();
    _detectFromDeviceList(devices);
  }

  /// Cập nhật loại output dựa trên thiết bị được thêm/xóa.
  void _updateOutputType(
    Set<AudioDevice> added,
    Set<AudioDevice> removed,
  ) {
    // Nếu có thiết bị mới được kết nối
    for (final device in added) {
      final type = _mapDeviceType(device.type);
      if (type != null) {
        _currentOutput = type;
        _deviceController.add(_currentOutput);
        return;
      }
    }

    // Nếu thiết bị bị ngắt kết nối → fallback về loa trong
    if (removed.isNotEmpty) {
      _currentOutput = AudioOutputType.speaker;
      _deviceController.add(_currentOutput);
    }
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
        return null; // Không phải tai nghe hay BT → dùng loa trong
    }
  }

  /// Giải phóng tài nguyên (gọi khi app đóng).
  void dispose() {
    _deviceController.close();
  }
}
