import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/datasources/user_activity_service.dart';
import '../../../domain/entities/artist_entity.dart';

class ArtistHeader extends StatefulWidget {
  final Artist artist;
  const ArtistHeader({super.key, required this.artist});

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
        // Background image
        Container(
          height: imageHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.artist.avatar),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Gradient overlay
        Container(
          height: imageHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.7),
                Colors.black,
              ],
              stops: [0.0, 0.7, 1.0],
            ),
          ),
        ),
        // Artist info
        Positioned(
          left: 16,
          right: 16,
          bottom: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.artist.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        // Action buttons
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
                      color: _isFollowing ? Colors.transparent : Colors.white70, 
                      width: 1.5
                    ),
                    backgroundColor: _isFollowing ? Colors.white24 : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    _isFollowing ? 'ĐANG QUAN TÂM' : 'QUAN TÂM',
                    style: const TextStyle(
                      color: Colors.white,
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
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C4DFF),
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
