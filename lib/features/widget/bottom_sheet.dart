import 'package:flutter/material.dart';
import '../../domain/entities/album_entity.dart';
import '../../domain/entities/song_entity.dart';
import '../managers/audio_player_manager.dart';
import '../managers/favorite_manager.dart';

class SongBottomSheet extends StatefulWidget {
  final Song song;
  final List<Song> songs;
  const SongBottomSheet({
    super.key,
    required this.song,
    required this.songs,
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height *0.4,
      color: Colors.grey[900],
      child: Column(
        children: [
          SizedBox(
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 24, right: 24),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: FadeInImage.assetNetwork(
                  placeholder: 'asset/itunes_256.png',
                  image: widget.song.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'asset/itunes_256.png',
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
                      title: 'Thêm vào danh sách yêu thích'
                  ),
                  SizedBox(height: 24,),
                  ActionButtonControl(
                      onTap: (){},
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

