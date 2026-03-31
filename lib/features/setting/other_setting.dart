import 'package:flutter/material.dart';
import 'package:music_app/core/services/audio_device_service.dart';
import 'package:music_app/core/services/firebase_auth_service.dart';
import 'package:music_app/features/wrapper/wrapper.dart';

import 'package:music_app/features/shared/widgets/buildMenuItem.dart';

class OtherSetting extends StatefulWidget {
  const OtherSetting({super.key});

  @override
  State<OtherSetting> createState() => _OtherSettingState();
}

class _OtherSettingState extends State<OtherSetting> {
  bool _pauseOnInterruption = true;

  @override
  void initState() {
    super.initState();
    _pauseOnInterruption = AudioDeviceService().pauseOnInterruptionEnabled;
  }

  Future<void> _togglePauseOnInterruption(bool value) async {
    await AudioDeviceService().setPauseOnInterruptionEnabled(value);
    setState(() => _pauseOnInterruption = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Khác'),
        elevation: 4,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Tạm dừng khi app khác phát âm thanh'),
            subtitle: _pauseOnInterruption
                ? const Text(
                    'Tự động dừng nhạc khi bạn mở video Facebook, YouTube hoặc chơi game.',
                  )
                : null,
            value: _pauseOnInterruption,
            onChanged: _togglePauseOnInterruption,
            secondary: const Icon(Icons.pause_circle_outline),
            activeThumbColor: Color(0xFF00D9D9),
            activeTrackColor: Color(0xFF00D9D9).withOpacity(0.3),
          ),
          const Divider(),
          buildMenuItem(Icons.delete_outlined, 'Xóa tài khoản', () {
            deleteAccountDialog(context, FirebaseAuthService());
          }),
        ],
      ),
    );
  }

  void deleteAccountDialog(BuildContext context, FirebaseAuthService service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade900
            : Colors.grey.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Xóa tài khoản',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Tài khoản bị xóa sẽ không thể khôi phục dữ liệu bao gồm bài hát yêu thích, playlist đã tạo, lịch sử nghe và nhiều dữ liệu khác. Bạn có chắc chắn muốn tiếp tục?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Hủy',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await service.deleteAccount();
              if (context.mounted) {
                // Navigate back to Wrapper and clear the navigation stack
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Wrapper()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Xác nhận xóa'),
          ),
        ],
      ),
    );
  }
}
