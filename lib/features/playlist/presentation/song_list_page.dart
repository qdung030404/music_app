import 'package:flutter/material.dart';
import '../../../data/datasources/user_activity_service.dart';
import '../../../data/repository/song_repository.dart';
import '../../../domain/entities/song_entity.dart';
import '../../../domain/usecases/get_songs.dart';

class SongListPage extends StatefulWidget {
  final String? playlistId; // Optional: if we want to directly add to a playlist

  const SongListPage({super.key, this.playlistId});

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  final GetSongs _getSongs = GetSongs(SongRepositoryImpl());
  List<Song> _allSongs = [];
  List<Song> _filteredSongs = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final songs = await _getSongs();
    if (mounted) {
      setState(() {
        _allSongs = songs ?? [];
        _filteredSongs = _allSongs;
        _isLoading = false;
      });
    }
  }

  void _filterSongs(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredSongs = _allSongs;
      } else {
        _filteredSongs = _allSongs
            .where((song) =>
                song.title.toLowerCase().contains(query.toLowerCase()) ||
                song.artistDisplay.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Tất cả bài hát', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterSongs,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm bài hát, nghệ sĩ...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
                : _filteredSongs.isEmpty
                    ? const Center(
                        child: Text(
                          'Không tìm thấy bài hát nào',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredSongs.length,
                        itemBuilder: (context, index) {
                          return _AddSongCard(
                            song: _filteredSongs[index],
                            playlistId: widget.playlistId,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _AddSongCard extends StatefulWidget {
  final Song song;
  final String? playlistId;

  const _AddSongCard({required this.song, this.playlistId});

  @override
  State<_AddSongCard> createState() => _AddSongCardState();
}

class _AddSongCardState extends State<_AddSongCard> {
  bool _isAdded = false;
  final UserActivityService _service = UserActivityService();

  Future<void> _handleAddSong() async {
    if (widget.playlistId == null || _isAdded) return;

    setState(() {
      _isAdded = true;
    });

    await _service.addSongToPlaylist(widget.playlistId!, widget.song);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã thêm "${widget.song.title}" vào playlist'),
          backgroundColor: Colors.deepPurple,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/itunes_256.png',
          image: widget.song.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/itunes_256.png',
              width: 50,
              height: 50,
            );
          },
        ),
      ),
      title: Text(
        widget.song.title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        widget.song.artistDisplay,
        style: const TextStyle(color: Colors.white70),
      ),
      trailing: IconButton(
        icon: Icon(
          _isAdded ? Icons.check_circle : Icons.add_circle_outline,
          color: _isAdded ? Colors.green : Colors.white,
          size: 28,
        ),
        onPressed: _handleAddSong,
      ),
      onTap: _handleAddSong,
    );
  }
}
