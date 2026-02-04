import 'package:flutter/material.dart';
import 'package:music_app/data/model/artist.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../data/datasources/user_activity_service.dart';
import '../../artist_detail/presentation/artist_detail.dart';

class FollowedList extends StatelessWidget {
  const FollowedList({super.key});

  @override
  Widget build(BuildContext context) {
    final userActivityService = UserActivityService();
    return StreamBuilder<List<Artist>>(
      stream: userActivityService.getFollowedArtist(),
      builder: (context, snapshot) {
        final followedArtist = snapshot.data ?? [];

        if (followedArtist.isEmpty) {
          return Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15), // Khoảng cách đẩy xuống giữa
              const FaIcon(
                  FontAwesomeIcons.music,
                  color: Colors.grey,
                  size: 160,
              ),
              const Text('bạn chưa theo dõi nghệ sĩ nào',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16
                ),
              ),
                const SizedBox(height: 8,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 48),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF06A0B5), // foreground
                  ),
                   onPressed: () { 
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text('Tính năng thêm nghệ sĩ đang được phát triển')),
                     );
                   },
                  child: const Text('THÊM NGHỆ SĨ', style: TextStyle(fontSize: 16)
                  ),
                )
            ],
          );
        }
        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: followedArtist.length,
              itemBuilder: (context, index) {
                final artist = followedArtist[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(artist.avatar),
                  ),
                  title: Text(
                    artist.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Nghệ sĩ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArtistDetail(artist: artist),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: (){ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tính năng thêm nghệ sĩ đang được phát triển')),
              );},
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 12,),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF06A0B5),
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Icon(Icons.add_circle_outline, color: Colors.white, size: 32),
                  ),
                  SizedBox(width: 16,),
                  Text('Thêm Nghệ Sĩ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
