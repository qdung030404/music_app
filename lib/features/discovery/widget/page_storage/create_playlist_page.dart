import 'package:flutter/material.dart';
import 'package:music_app/data/datasources/user_activity_service.dart';

import '../../../../domain/entities/playlist_entity.dart';

class CreatePlaylistPage extends StatefulWidget {
  final UserActivityService service;

  const CreatePlaylistPage({super.key, required this.service});

  @override
  State<CreatePlaylistPage> createState() => _CreatePlaylistPageState();
}

class _CreatePlaylistPageState extends State<CreatePlaylistPage> {
  final TextEditingController controller = TextEditingController();
  bool isPrivate = true;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: controller,

                decoration: InputDecoration(
                  labelText: 'Tên playlist',
                  floatingLabelStyle: const TextStyle(
                    color: Color(0xFF00D9D9),
                    fontWeight: FontWeight.bold,
                  ),
                  labelStyle: const TextStyle(color: Colors.grey),
                  hintText: ' Nhập tên playlist',
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF00D9D9),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              SwitchListTile(
                title: Text(
                  'Riêng tư',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                value: isPrivate,
                onChanged: (value) => setState(() => isPrivate = value),
                activeThumbColor: Color(0xFF00D9D9),
                activeTrackColor: Color(0xFF00D9D9).withOpacity(0.3),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00D9D9),
                  ),
                  onPressed: () => _handleCreatePlaylist(),
                  child: Text(
                    'TẠO',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCreatePlaylist() async {
    final name = controller.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên playlist')),
      );
      return;
    }
    try {
      final newPlaylist = Playlist(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        playlistName: name,
      );

      // Sử dụng widget.service thay vì biến service chưa khởi tạo
      await widget.service.createPlaylist(
        newPlaylist,
        isPrivate: isPrivate,
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Có lỗi xảy ra, vui lòng thử lại')),
        );
      }
    }
  }
}
