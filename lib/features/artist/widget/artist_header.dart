
import 'package:flutter/material.dart';
import '../../../data/datasources/user_activity_service.dart';
import '../../../domain/entities/artist_entity.dart';

class ArtistHeader extends StatefulWidget {
  final Artist artist;
  final VoidCallback? onPlayAll;
  const ArtistHeader({super.key, required this.artist, this.onPlayAll});

  @override
  State<ArtistHeader> createState() => _ArtistHeaderState();
}

class _ArtistHeaderState extends State<ArtistHeader> {
  final _userActivityService = UserActivityService();
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _checkFollowStatus();
  }

  Future<void> _checkFollowStatus() async {
    final following = await _userActivityService.isFollowing(widget.artist.id);
    if (mounted) {
      setState(() {
        _isFollowing = following;
      });
    }
  }

  Future<void> _toggleFollow() async {
    if (_isFollowing) {
      await _userActivityService.removeItem(widget.artist.id, 'followed');
    } else {
      await _userActivityService.addtoFollow(widget.artist);
    }
    if (mounted) {
      setState(() {
        _isFollowing = !_isFollowing;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.5;

    return Stack(
      children: [
        Container(
          height: imageHeight,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            image: widget.artist.avatar.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(widget.artist.avatar),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: widget.artist.avatar.isEmpty
              ? const Center(child: Icon(Icons.person, size: 100))
              : null,
        ),
        Container(
          height: imageHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.5),
                Colors.black,
              ],
              stops: const [0.6, 0.8, 1.0],
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.artist.name,
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _toggleFollow,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(
                      color: Colors.white,
                      width: 1.5
                    ),
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    _isFollowing ? 'ĐANG QUAN TÂM' : 'QUAN TÂM',
                    style: TextStyle(
                      color:  Colors.white ,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onPlayAll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D9D9),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'PHÁT NHẠC',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
