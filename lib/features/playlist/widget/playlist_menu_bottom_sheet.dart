import 'package:flutter/material.dart';
import 'package:music_app/domain/entities/playlist_entity.dart';

import '../../../data/datasources/user_activity_service.dart';
import '../presentation/song_list_page.dart';

class PlaylistMenuBottomSheet extends StatelessWidget {
  final Playlist playlist;
  final bool popAfterDelete; // Thêm biến này

  const PlaylistMenuBottomSheet({
    super.key,
    required this.playlist,
    this.popAfterDelete = false, // Mặc định là false
  });

  @override
  Widget build(BuildContext context) {
    final _userActivityService = UserActivityService();
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.deepPurple, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  ),
                  child: const Icon(Icons.playlist_play, color: Colors.white),
              ),
            ),
            title: Text(playlist.playlistName,
              style: TextStyle(
                color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            ),
            subtitle: const Text('Playlist', style: TextStyle(color: Colors.grey)),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            child: const Divider(thickness: 2, color: Colors.grey),
          ),
          // Các tùy chọn menu
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(Icons.add_circle_outline, 'Thêm bài hát', (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SongListPage(playlistId: playlist.id),
                    ),
                  );
                }),
                _buildMenuItem(Icons.edit, 'Chỉnh sửa tên playlist', () => _showUpdatePlaylistDialog(context, _userActivityService)),
                _buildMenuItem(Icons.arrow_circle_down, 'Chọn bài hát để tải', () {}),
                _buildMenuItem(Icons.delete_outline, 'Xóa playlist', () async {
                  await _userActivityService.removeItem(playlist.id, 'playlists');
                  if (context.mounted) {
                    Navigator.pop(context); // Luôn đóng BottomSheet
                    
                    if (popAfterDelete) {
                      Navigator.pop(context); // Chỉ đóng màn hình Detail nếu được yêu cầu
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã xóa playlist "${playlist.playlistName}"')),
                    );
                  }
                }),

              ],
            ),
          ),
        ],
      ),
    );
  }
  void _showUpdatePlaylistDialog(BuildContext context, UserActivityService service) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Chỉnh sửa tên playlist', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Tên playlist',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('HỦY', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {

                await service.updatePlaylistName(playlist.id, name);
                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }

              }
            },
            child: const Text('THAY ĐỔI', style: TextStyle(color: Colors.deepPurple)),
          ),
        ],
      ),
    );
  }
}
Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
  return ListTile(
    leading: Icon(icon, color: Colors.white),
    title: Text(title, style: const TextStyle(color: Colors.white)),
    onTap: onTap,
  );
}

