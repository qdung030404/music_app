import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/data/models/song.dart';
import 'package:music_app/features/shared/managers/audio_player_manager.dart';
import 'package:music_app/features/song_detail/view/song_detail.dart';
import 'package:text_scroll/text_scroll.dart';

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
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
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
                        return Image.asset(
                          'assets/itunes_256.png',
                          width: 48,
                          height: 48,
                        );
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
                      TextScroll(
                        song.title,
                        mode: TextScrollMode.endless,
                        velocity: const Velocity(
                          pixelsPerSecond: Offset(30, 0),
                        ),
                        delayBefore: const Duration(seconds: 1),
                        pauseBetween: const Duration(seconds: 2),
                        style: const TextStyle(
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
                  icon: const Icon(Icons.skip_previous),
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
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    } else if (playing != true) {
                      return IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: _audioPlayerManager.player.play,
                      );
                    } else {
                      return IconButton(
                        icon: const Icon(Icons.pause),
                        onPressed: _audioPlayerManager.player.pause,
                      );
                    }
                  },
                ),
                // Next
                IconButton(
                  icon: const Icon(Icons.skip_next),
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
