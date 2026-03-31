import 'package:flutter/material.dart';

import '../../../data/datasources/user_activity_service.dart';
import '../../../domain/entities/playlist_entity.dart';
import '../../../domain/entities/song_entity.dart';

class UpdatePlaylistPage extends StatefulWidget {
  final UserActivityService service;
  final Playlist playlist;

  const UpdatePlaylistPage({
    super.key,
    required this.service,
    required this.playlist,
  });

  @override
  State<UpdatePlaylistPage> createState() => _UpdatePlaylistPageState();
}

class _UpdatePlaylistPageState extends State<UpdatePlaylistPage> {
  late TextEditingController controller;
  late bool isPrivate;

  @override
  void initState() {
    super.initState();
    // Khởi tạo giá trị từ playlist hiện tại
    controller = TextEditingController(text: widget.playlist.playlistName);
    isPrivate = widget.playlist.isPrivate;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa Playlist'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                  hintText: 'Nhập tên playlist',
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF00D9D9),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 1.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text(
                  'Riêng tư',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                value: isPrivate,
                onChanged: (value) => setState(() => isPrivate = value),
                activeThumbColor: const Color(0xFF00D9D9),
                activeTrackColor: const Color(0xFF00D9D9).withOpacity(0.3),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D9D9),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: _handleUpdatePlaylist,
                  child: Text(
                    'CẬP NHẬT',
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
              const SizedBox(height: 30),
              StreamBuilder<List<Song>>(
                stream: widget.service.getPlaylistSongsStream(
                  widget.playlist.id,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00D9D9),
                      ),
                    );
                  }

                  final songs = snapshot.data ?? [];
                  if (songs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'Playlist chưa có bài hát nào',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Bài hát (${songs.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          final song = songs[index];
                          return _DeleteSongCard(
                            song: song,
                            onTap: () => _handleRemoveSong(song),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRemoveSong(Song song) async {
    try {
      await widget.service.removeSongFromPlaylist(widget.playlist.id, song.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xóa "${song.title}" khỏi playlist'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Có lỗi xảy ra khi xóa bài hát')),
        );
      }
    }
  }

  Future<void> _handleUpdatePlaylist() async {
    final name = controller.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên playlist')),
      );
      return;
    }

    try {
      // Gọi service cập nhật. Lưu ý: updatePlaylistName hiện đã hỗ trợ đồng bộ tên.
      await widget.service.updatePlaylistName(
        widget.playlist.id,
        name,
        isPrivate: isPrivate,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã cập nhật playlist thành công')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Có lỗi xảy ra, vui lòng thử lại')),
        );
      }
    }
  }
}

class _DeleteSongCard extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;

  const _DeleteSongCard({
    required this.song,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: song.image.isEmpty
            ? Image.asset(
                'assets/itunes_256.png',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            : FadeInImage.assetNetwork(
                placeholder: 'assets/itunes_256.png',
                image: song.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/itunes_256.png',
                    width: 50,
                    height: 50,
                  );
                },
              ),
      ),
      title: Text(
        song.title,
        style: const TextStyle(),
      ),
      subtitle: Text(
        song.artistDisplay,
        style: const TextStyle(),
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.delete_outlined,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          size: 28,
        ),
        onPressed: onTap,
      ),
      onTap: onTap,
    );
  }
}
