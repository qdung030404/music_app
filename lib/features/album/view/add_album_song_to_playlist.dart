import 'package:flutter/material.dart';
import 'package:music_app/data/datasources/jamendo_service.dart';
import 'package:music_app/data/models/song.dart';
import 'package:music_app/features/shared/widgets/playlist_bottom_sheet.dart';

class AddAlbumSongToPlaylist extends StatefulWidget {
  final String? albumId;

  const AddAlbumSongToPlaylist({super.key, this.albumId});

  @override
  State<AddAlbumSongToPlaylist> createState() => _AddAlbumSongToPlaylistState();
}

class _AddAlbumSongToPlaylistState extends State<AddAlbumSongToPlaylist> {
  List<Song> _allSongs = [];
  List<Song> _filteredSongs = [];
  bool _isLoading = true;
  final Set<String> _selectedSongIds = {};
  bool _isFavorite = false;

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
          _isFavorite = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
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
                  onPressed: () {
                    final songsToAdd = _selectedSongIds
                        .map((id) => _allSongs.firstWhere((s) => s.id == id))
                        .toList();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) =>
                          PlaylistBottomSheet(songs: songsToAdd),
                    );
                  },
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
