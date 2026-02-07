import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'package:music_app/features/managers/audio_player_manager.dart';
import 'package:music_app/domain/entities/song_entity.dart'; // Use Entity or Model
import 'package:music_app/features/song_detail/presentation/song_detail.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final AudioPlayerManager _audioPlayerManager = AudioPlayerManager();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Song?>(
      stream: _audioPlayerManager.currentSongStream,
      builder: (context, snapshot) {
        final song = snapshot.data;
        if (song == null) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () {
            // Navigate to Song Detail using GetX for better compatibility
            Get.to(
              () => SongDetail(
                playingSong: song,
                songs: _audioPlayerManager.playlist.isNotEmpty
                    ? _audioPlayerManager.playlist
                    : [song],
              ),
              transition: Transition.downToUp,
            );
          },
          child: Container(
            height: 64,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2E2E40), // Dark color matching theme
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                 BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                 ),
              ],
            ),
            child: Row(
              children: [
                // Image
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/itunes_256.png',
                      image: song.image,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/itunes_256.png', width: 48, height: 48);
                      },
                    ),
                  ),
                ),
                // Title & Artist
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        song.artistDisplay,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Controls
                // Prev
                IconButton(
                  icon: const Icon(Icons.skip_previous, color: Colors.white),
                  onPressed: () => _audioPlayerManager.skipToPrevious(),
                ),
                // Play/Pause
                StreamBuilder<PlayerState>(
                  stream: _audioPlayerManager.player.playerStateStream,
                  builder: (context, snapshot) {
                     final playerState = snapshot.data;
                     final processingState = playerState?.processingState;
                     final playing = playerState?.playing;
                     
                     if (processingState == ProcessingState.loading || 
                         processingState == ProcessingState.buffering) {
                       return const SizedBox(
                         width: 48, 
                         height: 48, 
                         child: Padding(
                           padding: EdgeInsets.all(12),
                           child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white,),
                         ),
                       );
                     } else if (playing != true) {
                       return IconButton(
                         icon: const Icon(Icons.play_arrow, color: Colors.white),
                         onPressed: _audioPlayerManager.player.play,
                       );
                     } else {
                       return IconButton(
                         icon: const Icon(Icons.pause, color: Colors.white),
                         onPressed: _audioPlayerManager.player.pause,
                       );
                     }
                  }
                ),
                // Next
                IconButton(
                  icon: const Icon(Icons.skip_next, color: Colors.white),
                  onPressed: () => _audioPlayerManager.skipToNext(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
