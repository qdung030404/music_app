import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_app/features/discovery/presentation/favorite_song.dart';
import 'package:music_app/features/discovery/presentation/follow_artist.dart';

List<Map<String, dynamic>> items = [

  {
    'icon': Icons.favorite_border,
    'color': Colors.blueAccent,
    'text': 'Yêu thích'
  },
  {
    'icon': Icons.arrow_circle_down_outlined,
    'color': Colors.deepPurple,
    'text': 'Đã tải'
  },
  {
    'icon': Icons.music_note,
    'color': Colors.orangeAccent,
    'text': 'Nghệ sĩ'
  }

];
class LibraryCardList extends StatelessWidget {
  const LibraryCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.length,
              itemBuilder: (context, index){
                return Padding(padding:
                const EdgeInsets.only(right: 12),
                  child: libraryCard(context,items[index]),
                );
              },
          )
        )
      ],
    );
  }
  Widget libraryCard(BuildContext context, Map<String, dynamic> item){
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 3 - 16;
    return GestureDetector(
      onTap: () {
        if (item['text'] == 'Yêu thích') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavoriteSong()),
          );
        } else if (item['text'] == 'Nghệ sĩ') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FollowArtist()),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.only(top: 32, bottom: 20),
        width: itemWidth,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[800]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FaIcon(
              item['icon'],
              size: 40,
              color: item['color'],
            ),
            SizedBox(height: 8),
            Text(
              item['text'],
              style: TextStyle(
                color:  item['color'],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
