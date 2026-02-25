import 'package:flutter/material.dart';
import '../../domain/entities/album_entity.dart';
import '../../domain/entities/song_entity.dart';
import '../../data/datasources/user_activity_service.dart';
import '../managers/favorite_manager.dart';
import 'playlist_bottom_sheet.dart';

class SongBottomSheet extends StatefulWidget {
  final Song song;
  final List<Song> songs;
  final String? playlistId;
  const SongBottomSheet({
    super.key,
    required this.song,
    required this.songs,
    this.playlistId,
  });

  @override
  State<SongBottomSheet> createState() => _SongBottomSheetState();
}

class _SongBottomSheetState extends State<SongBottomSheet> {
  late FavoriteManager _favoriteManager;
  bool _isFavorite = false;
  late Album album;
  @override
  void initState() {
    super.initState();
    _favoriteManager = FavoriteManager();
    _loadFavoriteState(widget.song.id);
  }
  Future<void> _handleToggleFavorite(Song song) async {
    await _favoriteManager.toggleFavorite(song, _isFavorite);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  Future<void> _loadFavoriteState(String songId) async {
    final isFav = await _favoriteManager.checkIsFavorite(songId);
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isFavorite = isFav;
          });
        }
      });
    }
  }

  Future<void> _handleRemoveFromPlaylist() async {
    if (widget.playlistId != null) {
      final service = UserActivityService();
      await service.removeSongFromPlaylist(widget.playlistId!, widget.song.id);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xóa bài hát khỏi playlist'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height *0.4,
      color: Colors.grey[900],
      child: Column(
        children: [
          SizedBox(
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 12, right: 12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/itunes_256.png',
                  image: widget.song.image,
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
              title: Text(widget.song.title,
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              subtitle: Text(widget.song.artistDisplay,
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            child: Divider(thickness: 4, color: Colors.grey),
          ),
          SizedBox(height: 12,),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 24,),
                  ActionButtonControl(
                      onTap: (){ },
                      icon: Icons.arrow_circle_down,
                      title: 'Tải về',
                      color: Colors.white,
                  ),
                  SizedBox(height: 24,),
                  ActionButtonControl(
                      onTap: ()=> _handleToggleFavorite(widget.song),
                      icon: _isFavorite ? Icons.favorite : Icons.favorite_outline,
                      color: _isFavorite ? Colors.red : Theme.of(context).colorScheme.primary,
                      title: _isFavorite ? 'Đã Thêm vào danh sách yêu thích' : 'Thêm vào danh sách yêu thích'
                  ),
                  SizedBox(height: 24,),
                  widget.playlistId != null 
                  ? ActionButtonControl(
                      onTap: _handleRemoveFromPlaylist,
                      icon: Icons.playlist_remove,
                      title: 'Xóa khỏi playlist',
                      color: Colors.white,
                  )
                  : ActionButtonControl(
                      onTap: () {
                        Navigator.pop(context); // Close the song bottom sheet
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => PlaylistBottomSheet(song: widget.song)
                        );
                      },
                      icon: Icons.playlist_add,
                      title: 'Thêm vào playlist',
                      color: Colors.white,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ActionButtonControl extends StatefulWidget {
  final void Function() onTap;
  final IconData icon;
  final String title;
  final Color? color;
  const ActionButtonControl({
    super.key,
    required this.onTap,
    required this.icon,
    required this.color,
    required this.title
  });

  @override
  State<ActionButtonControl> createState() => _ActionButtonControlState();
}

class _ActionButtonControlState extends State<ActionButtonControl> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 20,),
          Icon(widget.icon, color: widget.color, size: 36),
          SizedBox(width: 16,),
          Expanded(
            child: Text(widget.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.normal
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}

