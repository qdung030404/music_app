import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/features/managers/audio_player_manager.dart';
import 'package:music_app/features/managers/favorite_manager.dart';

class SongDetail extends StatelessWidget {
  const SongDetail({super.key, required this.songs, required this.playingSong});
  final List<Song> songs;
  final Song playingSong;
  @override
  Widget build(BuildContext context) {
    return SongDetailPage(
      songs: songs,
      playingSong: playingSong,
    );
  }
}

class SongDetailPage extends StatefulWidget {
  const SongDetailPage({super.key, required this.songs, required this.playingSong});
  final List<Song> songs;
  final Song playingSong;
  @override
  State<SongDetailPage> createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage> with SingleTickerProviderStateMixin{
  late AnimationController _animationController;
  late AudioPlayerManager _audioPlayerManager;
  late FavoriteManager _favoriteManager;
  late double _animationPosition;
  bool _isShuffle = false;
  bool _isFavorite = false;
  late LoopMode _loopMode;

  @override
  void initState() {
    super.initState();
    _animationPosition = 0.0;
    _loopMode = LoopMode.off;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 12000),
    );
    _audioPlayerManager = AudioPlayerManager();
    _favoriteManager = FavoriteManager();

    _audioPlayerManager.currentSongStream.listen((song) {
      if (song != null) {
        _loadFavoriteState(song.id);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_audioPlayerManager.currentSong?.id != widget.playingSong.id) {
        int index = widget.songs.indexOf(widget.playingSong);
        if (index == -1) index = 0;
        _audioPlayerManager.setPlaylist(widget.songs, index);
      }
    });

    _loadFavoriteState(widget.playingSong.id);
    _isShuffle = _audioPlayerManager.isShuffle;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.08;

    return StreamBuilder<Song?>(
      stream: _audioPlayerManager.currentSongStream,
      builder: (context, snapshot) {
        final _song = snapshot.data ?? widget.playingSong;
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              children: [
                const Text(
                  'Phát từ:',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  _song.title, // Using album as playlist proxy if needed
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF06A0B5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, color: Colors.white),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      _song.albumDisplay,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Container(
                      width: screenWidth - (padding * 2),
                      height: screenWidth - (padding * 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/itunes_256.png',
                          image: _song.image,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/itunes_256.png',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Song Info & Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _song.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _song.artistDisplay,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.download_outlined, color: Colors.white70, size: 28),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.share_outlined, color: Colors.white70),
                          ),
                          IconButton(
                            onPressed: () => _handleToggleFavorite(_song),
                            icon: Icon(
                              _isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: _isFavorite ? const Color(0xFF06A0B5) : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Progress Bar
                  _progressBar(),
                  const SizedBox(height: 32),
                  
                  // Playback Controls
                  _mediaButton(),
                  
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  StreamBuilder<DurationState> _progressBar() {
    return StreamBuilder<DurationState>(
      stream: _audioPlayerManager.durationState,
      builder: (context, snapshot) {
        final durationState = snapshot.data;
        final progress = durationState?.progress ?? Duration.zero;
        final total = durationState?.total ?? Duration.zero;

        return Column(
          children: [
            ProgressBar(
              progress: progress,
              total: total,
              buffered: durationState?.buffered ?? Duration.zero,
              onSeek: _audioPlayerManager.player.seek,
              barHeight: 4,
              baseBarColor: Colors.white24,
              progressBarColor: const Color(0xFF06A0B5),
              thumbColor: const Color(0xFF06A0B5),
              thumbRadius: 6,
              timeLabelLocation: TimeLabelLocation.below,
              timeLabelTextStyle: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        );
      },
    );
  }

  StreamBuilder<PlayerState> _playerState() {
    return StreamBuilder<PlayerState>(
      stream: _audioPlayerManager.player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;

        if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
          return Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(16),
            child: const CircularProgressIndicator(color: Color(0xFF06A0B5)),
          );
        } else if (playing != true) {
          return GestureDetector(
            onTap: () => _audioPlayerManager.player.play(),
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF06A0B5),
              ),
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 48),
            ),
          );
        } else if (processingState != ProcessingState.completed) {
          return GestureDetector(
            onTap: () => _audioPlayerManager.player.pause(),
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF06A0B5),
              ),
              child: const Icon(Icons.pause, color: Colors.white, size: 48),
            ),
          );
        } else {
          return GestureDetector(
            onTap: () => _audioPlayerManager.player.seek(Duration.zero),
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF06A0B5),
              ),
              child: const Icon(Icons.replay, color: Colors.white, size: 48),
            ),
          );
        }
      },
    );
  }

  void setNextSong() {
    _audioPlayerManager.skipToNext();
  }

  void setPreviousSong() {
    _audioPlayerManager.skipToPrevious();
  }

  void _setRepeatOption() {
    if (_loopMode == LoopMode.off) {
      _loopMode = LoopMode.one;
    } else if (_loopMode == LoopMode.one) {
      _loopMode = LoopMode.all;
    } else {
      _loopMode = LoopMode.off;
    }
    _audioPlayerManager.setLoopMode(_loopMode);
    setState(() {});
  }

  IconData _repeatingIcon() {
    return switch (_loopMode) {
      LoopMode.all => Icons.repeat,
      LoopMode.one => Icons.repeat_one,
      _ => Icons.repeat,
    };
  }

  void _setShuffle() {
    _isShuffle = !_isShuffle;
    _audioPlayerManager.setShuffle(_isShuffle);
    setState(() {});
  }

  Widget _mediaButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Shuffle with pill background
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: _isShuffle ? Colors.white10 : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            onPressed: _setShuffle,
            icon: Icon(
              Icons.shuffle,
              color: _isShuffle ? const Color(0xFF06A0B5) : Colors.white70,
              size: 24,
            ),
          ),
        ),
        
        IconButton(
          onPressed: setPreviousSong,
          icon: const Icon(Icons.skip_previous, color: Colors.white, size: 40),
        ),
        
        _playerState(),
        
        IconButton(
          onPressed: setNextSong,
          icon: const Icon(Icons.skip_next, color: Colors.white, size: 40),
        ),

        IconButton(
          onPressed: _setRepeatOption,
          icon: Icon(
            _repeatingIcon(),
            color: _loopMode == LoopMode.off ? Colors.white70 : const Color(0xFF06A0B5),
            size: 24,
          ),
        ),
      ],
    );
  }
}