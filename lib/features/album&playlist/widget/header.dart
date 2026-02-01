import 'package:flutter/material.dart';
import 'package:music_app/domain/entities/album_entity.dart';

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
      child: SingleChildScrollView(
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
            customText(album.artistDisplay, 18, FontWeight.normal), // Ideally should be artist name
            const SizedBox(height: 8),
            customText('Album', 14, FontWeight.normal),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _actionButton(
                    icon: Icons.arrow_circle_down_outlined,
                    label: 'Tải về',
                    onTap: onDownload,
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
                      onPressed: onPlayShuffle,
                      child: customText('PHÁT NGẪU NHIÊN', 16, FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 24),
                  _actionButton(
                    icon: Icons.favorite_outline,
                    label: 'Yêu thích',
                    onTap: onFavorite,
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

  Widget _actionButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: Colors.white),
          const SizedBox(height: 4),
          customText(label, 12, FontWeight.normal),
        ],
      ),
    );
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
}
