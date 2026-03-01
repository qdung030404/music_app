import 'package:flutter/material.dart';
import '../../../data/datasources/user_activity_service.dart';
import '../../../data/repository/song_repository.dart';
import '../../../domain/entities/song_entity.dart';
import '../../../domain/usecases/get_songs.dart';

class SongListPage extends StatefulWidget {
  final String? playlistId;
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
  final Set<String> _selectedSongIds = {};
  final UserActivityService _userActivityService = UserActivityService();

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
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
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
                          final song = _filteredSongs[index];
                          final isSelected = _selectedSongIds.contains(song.id);
                          return _AddSongCard(
                            song: song,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedSongIds.remove(song.id);
                                } else {
                                  _selectedSongIds.add(song.id);
                                }
                              });
                            },
                          );
                        },
                      ),
          ),
          if (_selectedSongIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _handleSaveSelectedSongs,
                  child: const Text(
                    'XONG',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleSaveSelectedSongs() async {
    if (widget.playlistId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      for (final songId in _selectedSongIds) {
        final song = _allSongs.firstWhere((s) => s.id == songId);
        await _userActivityService.addSongToPlaylist(widget.playlistId!, song);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã thêm bài hát vào playlist'),
            backgroundColor: Colors.deepPurple,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Có lỗi xảy ra: $e')),
        );
      }
    }
  }
}

class _AddSongCard extends StatelessWidget {
  final Song song;
  final bool isSelected;
  final VoidCallback onTap;

  const _AddSongCard({
    required this.song,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: song.image.isEmpty
            ? Image.asset(
                'assets/itunes_256.png',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            : FadeInImage.assetNetwork(
                placeholder: 'assets/itunes_256.png',
                image: song.image,
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
        song.title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        song.artistDisplay,
        style: const TextStyle(color: Colors.white70),
      ),
      trailing: IconButton(
        icon: Icon(
          isSelected ? Icons.check_circle : Icons.add_circle_outline,
          color: isSelected ? Colors.green : Colors.white,
          size: 28,
        ),
        onPressed: onTap,
      ),
      onTap: onTap,
    );
  }
}
