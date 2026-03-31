import 'package:flutter/material.dart';
import 'package:music_app/data/datasources/jamendo_service.dart';
import 'package:music_app/data/model/song.dart';

import '../../../../data/datasources/user_activity_service.dart';

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
      final List<Song> s = songsData
          .map<Song>(
            (e) => SongModel(
              id: e['id']?.toString() ?? '',
              title: e['name'] ?? 'Unknown',
              albumId: e['album_id']?.toString() ?? '',
              artistId: e['artist_id']?.toString() ?? '',
              albumName: e['album_name'],
              artistName: e['artist_name'],
              source: e['audio'] ?? '',
              image: e['image'] ?? e['album_image'] ?? '',
              duration: e['duration'] ?? 180,
            ),
          )
          .toList();

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
            .where(
              (song) =>
                  song.title.toLowerCase().contains(query.toLowerCase()) ||
                  song.artistDisplay.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
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
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                if (_selectedSongIds.length == _filteredSongs.length &&
                    _filteredSongs.isNotEmpty) {
                  _selectedSongIds.clear();
                } else {
                  _selectedSongIds.addAll(_filteredSongs.map((s) => s.id));
                }
              });
            },
            child: Text(
              _selectedSongIds.length == _filteredSongs.length &&
                      _filteredSongs.isNotEmpty
                  ? 'Bỏ chọn tất cả'
                  : 'Chọn tất cả',
              style: const TextStyle(color: Color(0xFF00D9D9)),
            ),
          ),
        ],
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
                ? const Center(
                    child: CircularProgressIndicator(
                      color: const Color(0xFF00D9D9),
                    ),
                  )
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
                    backgroundColor: const Color(0xFF00D9D9),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _handleSaveSelectedSongs,
                  child: const Text(
                    'XONG',
                    style: TextStyle(
                      color: Colors.black,
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
      final songsToAdd = _selectedSongIds
          .map((id) => _allSongs.firstWhere((s) => s.id == id))
          .toList();
      await _userActivityService.addSongsToPlaylist(
        widget.playlistId!,
        songsToAdd,
      );

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
          color: isSelected
              ? Color(0xFF00D9D9)
              : Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          size: 28,
        ),
        onPressed: onTap,
      ),
      onTap: onTap,
    );
  }
}
