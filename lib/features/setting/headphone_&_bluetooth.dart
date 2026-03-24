import 'package:flutter/material.dart';
import 'package:music_app/core/services/audio_device_service.dart';

class HeadphoneBluetooth extends StatefulWidget {
  const HeadphoneBluetooth({super.key});

  @override
  State<HeadphoneBluetooth> createState() => _HeadphoneBluetoothState();
}

class _HeadphoneBluetoothState extends State<HeadphoneBluetooth> {
  bool _autoPause = true;
  bool _autoContinuePlaying = true;
  bool _mediaButtonControl = true;
  @override
  void initState() {
    super.initState();
    // Đọc giá trị hiện tại từ service
    _autoPause = AudioDeviceService().autoPauseEnabled;
    _autoContinuePlaying = AudioDeviceService().autoContinuePlayingEnabled;
    _mediaButtonControl = AudioDeviceService().mediaButtonControlEnabled;
  }

  Future<void> _toggleAutoPause(bool value) async {
    await AudioDeviceService().setAutoPauseEnabled(value);
    setState(() => _autoPause = value);
  }
  Future<void> _toggleAutoContinuePlaying(bool value) async {
    await AudioDeviceService().setAutoContinuePlayingEnabled(value);
    setState(() => _autoContinuePlaying = value);
  }
  Future<void> _toggleMediaControl(bool value) async {
    await AudioDeviceService().setMediaButtonControlEnabled(value);
    setState(() => _mediaButtonControl = value);
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tai nghe & Bluetooth'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                'Tai nghe / Loa',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                )
              )
            ),

            _SettingTile(
              title: 'tạm dừng phát khi ngắt kết nối',
              trailing: Switch(
                value: _autoPause,
                onChanged: _toggleAutoPause,
                activeThumbColor: Color(0xFF00D9D9),
                activeTrackColor: Color(0xFF00D9D9).withOpacity(0.3)
              )
            ),
            _SettingTile(
              title: 'phát tiếp khi kết nối',
              trailing: Switch(
                value: _autoContinuePlaying,
                onChanged: _toggleAutoContinuePlaying,
                activeThumbColor: Color(0xFF00D9D9),
                activeTrackColor: Color(0xFF00D9D9).withOpacity(0.3)
              )
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Text(
                    'Thiết bị bluetooth',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    )
                )
            ),
            _SettingTile(
                title: 'Cho phép điều khiển bằng phím tai nghe',
                trailing: Switch(
                  value: _mediaButtonControl,
                  onChanged: _toggleMediaControl,
                    activeThumbColor: Color(0xFF00D9D9),
                    activeTrackColor: Color(0xFF00D9D9).withOpacity(0.3)
                )
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.title,
    required this.trailing,
  });

  final String title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: trailing,
    );
  }
}
