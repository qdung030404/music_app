import 'package:flutter/material.dart';
import 'package:music_app/domain/entities/playlist_entity.dart';
import '../../../domain/entities/song_entity.dart';

class PlaylistHeader extends StatefulWidget {
  final Playlist playlist;
  final VoidCallback? onPlayAll;
  final List<Song> songs;
  const PlaylistHeader({
    super.key,
    required this.playlist,
    required this.songs,
    this.onPlayAll,
  });

  @override
  State<PlaylistHeader> createState() => _PlaylistHeaderState();
}

class _PlaylistHeaderState extends State<PlaylistHeader> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        width: double.infinity,
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 60),
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 15,
                  )
                ],
              ),
              child: const Icon(
                Icons.playlist_play,
                color: Colors.white,
                size: 100,
              ),
            ),
            const SizedBox(height: 24),
            _customText(widget.playlist.playlistName, 28, FontWeight.bold),
            const SizedBox(height: 8),
            _customText('Playlist của tôi', 18, FontWeight.normal),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: widget.songs.isEmpty
                  ? Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                          backgroundColor: const Color(0xFF06A0B5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          // TODO: Navigate to discovery to add songs
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: _customText('THÊM BÀI HÁT', 16, FontWeight.bold),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.arrow_circle_down_outlined,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: const Color(0xFF06A0B5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: widget.onPlayAll,
                            child: _customText('PHÁT TẤT CẢ', 16, FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 32),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add_circle_outline,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _customText(String text, double? size, FontWeight? fontWeight) {
    size ??= 16;
    fontWeight ??= FontWeight.normal;
    return Text(
      text,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: size,
        color: Colors.white,
        fontWeight: fontWeight,
      ),
    );
  }
}
