import 'package:flutter/material.dart';
import 'package:music_app/domain/entities/album_entity.dart';

import '../../../data/datasources/user_activity_service.dart';
import '../../../domain/entities/song_entity.dart';
import '../../widget/download_song.dart';


class Header extends StatelessWidget {
  final Album album;
  final List<Song> songs;
  final VoidCallback? onPlayShuffle;
  final VoidCallback? onFavorite;
  final VoidCallback? onDownload;

  const Header({
    super.key,
    required this.album,
    required this.songs,
    this.onPlayShuffle,
    this.onFavorite,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 80), // Add space for back button in SliverAppBar
          Container(
            width: MediaQuery.of(context).size.width/ 2,
            height: MediaQuery.of(context).size.width/ 2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
             ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: album.image.isNotEmpty
                  ? Image.network(
                      album.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[900],
                        child: const Icon(Icons.album, color: Colors.white54, size: 80),
                      ),
                    )
                  : Container(
                      color: Colors.grey[900],
                      child: const Icon(Icons.album, color: Colors.white54, size: 80),
                    ),
            ),
          ),
          const SizedBox(height: 15),
          customText(album.albumTitle, 20, FontWeight.bold),
          const SizedBox(height: 8),
          customText(album.artistDisplay, 16, FontWeight.normal),
          const SizedBox(height: 8),
          customText('Album', 12, FontWeight.normal),
          const SizedBox(height: 15),
          HeaderAction(
            album: album,
            songs: songs,
            onPlayShuffle: onPlayShuffle,
            onDownload: onDownload,
          ),

        ],
      ),
    );
  }
}

class HeaderAction extends StatefulWidget {
  final Album album;
  final List<Song> songs;
  final VoidCallback? onPlayShuffle;
  final VoidCallback? onDownload;

  const HeaderAction({
    super.key,
    required this.album,
    required this.songs,
    this.onPlayShuffle,
    this.onDownload,
  });

  @override
  State<HeaderAction> createState() => _HeaderActionState();
}

class _HeaderActionState extends State<HeaderAction> {
  final _userActivityService = UserActivityService();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIsFavorite(widget.album.id);
  }

  Future<void> _toggleFavorite(Album album) async {
    if (_isFavorite) {
      await _userActivityService.removeItem(album.id, 'albums');
    } else {
      await _userActivityService.addFavoriteAlbum(album);
    }
    if (mounted) {
      setState(() {
        _isFavorite = !_isFavorite;
      });
    }
  }

  Future<void> _checkIsFavorite(String albumId) async {
    final isFav = await _userActivityService.isFavorite(albumId, 'albums');
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: (){
              Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context) => DownloadSong(songs: widget.songs,)
              )
              );
            },
            icon: const Icon(Icons.arrow_circle_down_outlined, size: 28),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                backgroundColor: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: widget.onPlayShuffle,
              child: Text('PHÁT NGẪU NHIÊN',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          IconButton(
            onPressed: () => _toggleFavorite(widget.album),
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_outline, size: 28),
            color: _isFavorite ? Colors.red : Colors.white,
          ),
        ],
      ),
    );
  }
}

Widget customText(String text, double? size, FontWeight? fontWeight) {
  size ??= 16;
  fontWeight ??= FontWeight.normal;
  return Text(
    text,
    textAlign: TextAlign.center,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: size,
      fontWeight: fontWeight,
    ),
  );
}
