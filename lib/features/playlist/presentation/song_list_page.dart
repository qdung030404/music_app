import 'package:flutter/material.dart';
import '../../../data/datasources/user_activity_service.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/data/datasources/jamendo_service.dart';

class SongListPage extends StatefulWidget {
  final String? playlistId;
  const SongListPage({super.key, this.playlistId});

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
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
    final jamendo = JamendoService();
    try {
      final songsData = await jamendo.fetchPopularTracks();
      final List<Song> s = songsData.map<Song>((e) => SongModel(
        id: e['id']?.toString() ?? '',
        title: e['name'] ?? 'Unknown',
        albumId: e['album_id']?.toString() ?? '',
        artistId: e['artist_id']?.toString() ?? '',
        albumName: e['album_name'],
        artistName: e['artist_name'],
        source: e['audio'] ?? '',
        image: e['image'] ?? e['album_image'] ?? '',
        duration: e['duration'] ?? 180,
      )).toList();

      if (mounted) {
        setState(() {
          _allSongs = s;
          _filteredSongs = _allSongs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
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
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
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
                          style: TextStyle(),
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
        style: const TextStyle(),
      ),
      subtitle: Text(
        song.artistDisplay,
        style: const TextStyle(),
      ),
      trailing: IconButton(
        icon: Icon(
          isSelected ? Icons.check_circle : Icons.add_circle_outline,
          size: 28,
        ),
        onPressed: onTap,
      ),
      onTap: onTap,
    );
  }
}
