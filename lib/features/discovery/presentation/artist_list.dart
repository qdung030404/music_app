import 'package:flutter/material.dart';
import '../../../data/datasources/user_activity_service.dart';
import 'package:music_app/data/datasources/jamendo_service.dart';
import 'package:music_app/data/model/artist.dart';

class ArtistList extends StatefulWidget {
  const ArtistList({super.key});

  @override
  State<ArtistList> createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> {
  List<Artist> _allArtists = [];
  List<Artist> _filteredArtists = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final Set<String> _selectedArtistIds = {};
  final UserActivityService _userActivityService = UserActivityService();

  @override
  void initState() {
    super.initState();
    _loadArtists();
  }

  Future<void> _loadArtists() async {
    try {
      final jamendo = JamendoService();
      final data = await jamendo.fetchPopularArtists();
      
      final List<Artist> artists = data
        .where((e) => e['image'] != null && e['image'].toString().trim().isNotEmpty)
        .map<Artist>((e) => ArtistModel(
        id: e['id']?.toString() ?? '',
        name: e['name'] ?? 'Unknown',
        avatar: e['image'] ?? '',
      )).toList();

      if (mounted) {
        setState(() {
          _allArtists = artists;
          _filteredArtists = artists;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Error loading artists: $e');
    }
  }

  void _filterArtists(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredArtists = _allArtists;
      } else {
        _filteredArtists = _allArtists
            .where((artist) =>
                artist.name.toLowerCase().contains(query.toLowerCase()))
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
              onChanged: _filterArtists,
              style: const TextStyle(),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm nghệ sĩ...',
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
                : _filteredArtists.isEmpty
                    ? const Center(
                        child: Text(
                          'Không tìm thấy nghệ sĩ nào',
                          style: TextStyle(),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _filteredArtists.length,
                        itemBuilder: (context, index) {
                          final artist = _filteredArtists[index];
                          final isSelected = _selectedArtistIds.contains(artist.id);
                          return _ArtistCard(
                            artist: artist,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedArtistIds.remove(artist.id);
                                } else {
                                  _selectedArtistIds.add(artist.id);
                                }
                              });
                            },
                          );
                        },
                      ),
          ),
          if (_selectedArtistIds.isNotEmpty)
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
                  onPressed: _handleFollowSelected,
                  child: Text(
                    'XONG',
                    style: const TextStyle(
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

  Future<void> _handleFollowSelected() async {
    setState(() {
      _isLoading = true;
    });

    try {
      for (final artistId in _selectedArtistIds) {
        final artist = _allArtists.firstWhere((a) => a.id == artistId);
        await _userActivityService.addtoFollow(artist);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã theo dõi các nghệ sĩ đã chọn'),
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

class _ArtistCard extends StatelessWidget {
  final Artist artist;
  final bool isSelected;
  final VoidCallback onTap;

  const _ArtistCard({
    required this.artist,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: artist.avatar.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(artist.avatar),
                            fit: BoxFit.cover,
                          )
                        : const DecorationImage(
                            image: AssetImage('assets/itunes_256.png'),
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: artist.avatar.isEmpty
                      ? const Center(
                          child: Icon(Icons.person, size: 40))
                      : null,
                ),
                if (isSelected)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.deepPurple,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            artist.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
