import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_app/features/discovery/presentation/downloaded.dart';
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
    'text': 'Tải về'
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
          height: MediaQuery.of(context).size.height *0.13,
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
        } else if (item['text'] == 'Tải về'){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Downloaded())
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: itemWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade900
              : Colors.grey.shade200,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              item['icon'],
              size: 40,
              color: item['color'],
            ),
            const SizedBox(height: 8),
            Text(
              item['text'],
              style: TextStyle(
                color:  item['color'],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
