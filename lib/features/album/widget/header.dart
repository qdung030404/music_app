import 'package:flutter/material.dart';
import 'package:music_app/domain/entities/album_entity.dart';

import '../../../data/datasources/user_activity_service.dart';


class Header extends StatelessWidget {
  final Album album;
  final VoidCallback? onPlayShuffle;
  final VoidCallback? onFavorite;
  final VoidCallback? onDownload;

  const Header({
    super.key,
    required this.album,
    this.onPlayShuffle,
    this.onFavorite,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 60), // Add space for back button in SliverAppBar
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 15,
                  )
                ],
                image: DecorationImage(
                  image: NetworkImage(album.image),
                  fit: BoxFit.cover,
                )),
          ),
          const SizedBox(height: 24),
          customText(album.albumTitle, 28, FontWeight.bold),
          const SizedBox(height: 8),
          customText(album.artistDisplay, 18, FontWeight.normal),
          const SizedBox(height: 8),
          customText('Album', 14, FontWeight.normal),
          const SizedBox(height: 24),
          HeaderAction(
            album: album,
            onPlayShuffle: onPlayShuffle,
            onDownload: onDownload,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class HeaderAction extends StatefulWidget {
  final Album album;
  final VoidCallback? onPlayShuffle;
  final VoidCallback? onDownload;

  const HeaderAction({
    super.key,
    required this.album,
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
            onPressed: widget.onDownload,
            icon: const Icon(Icons.arrow_circle_down_outlined, size: 28, color: Colors.white),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: widget.onPlayShuffle,
              child: customText('PHÁT NGẪU NHIÊN', 16, FontWeight.bold),
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
      color: Colors.white,
      fontWeight: fontWeight,
    ),
  );
}
