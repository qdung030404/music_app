import 'package:flutter/material.dart';

import '../../domain/entities/song_entity.dart';

class SongBottomSheet extends StatelessWidget {
  final Song song;
  final List<Song> songs;
  const SongBottomSheet({super.key, required this.song, required this.songs});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height *0.45,
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
                  image: song.image,
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
              title: Text(song.title,
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              subtitle: Text(song.artistDisplay,
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
          _actionButton(),
        ],
      ),
    );
  }
}
Widget _actionButton(){
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(height: 24,),
      ActionButtonControl(funtion: (){}, icon: Icons.arrow_circle_down, title: 'Tải về'),
      SizedBox(height: 24,),
      ActionButtonControl(funtion: (){}, icon: Icons.favorite_outline, title: 'Thêm vào danh sách yêu thích'),
      SizedBox(height: 24,),
      ActionButtonControl(funtion: (){}, icon: Icons.playlist_add, title: 'Thêm vào playlist'),
      SizedBox(height: 24,),
      ActionButtonControl(funtion: (){}, icon: Icons.queue_play_next, title: 'Phát kế tiếp'),
      SizedBox(height: 24,),
      ActionButtonControl(funtion: (){}, icon: Icons.audio_file, title: 'Xem album'),
      SizedBox(height: 24,),
      ActionButtonControl(funtion: (){}, icon: Icons.queue_music, title: 'Xem nghệ sĩ'),

    ],
  );
}
class ActionButtonControl extends StatefulWidget {
  final void Function() funtion;
  final IconData icon;
  final String title;
  const ActionButtonControl({
    super.key,
    required this.funtion,
    required this.icon,
    required this.title
  });

  @override
  State<ActionButtonControl> createState() => _ActionButtonControlState();
}

class _ActionButtonControlState extends State<ActionButtonControl> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 20,),
          Icon(widget.icon, color: Colors.white, size: 36),
          SizedBox(width: 16,),
          Text(widget.title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.normal
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

