import 'dart:async';
import 'package:flutter/material.dart';
import '../widget/Search_history.dart';
import '../widget/search_results_list.dart';
import 'package:music_app/data/datasources/jamendo_service.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/data/model/artist.dart';
import 'package:music_app/data/model/album.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _searchHistory = [];
  Timer? _debounce;
  late stt.SpeechToText _speechToText;
  bool _isListening = false;
  
  List<Song> _allSongs = [];
  List<Artist> _allArtists = [];
  List<Album> _allAlbums = [];
  
  List<Song> _filteredSongs = [];
  List<Artist> _filteredArtists = [];
  List<Album> _filteredAlbums = [];

  bool _isLoading = true;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadAllData();
    _searchController.addListener(_onSearchChanged);
    _speechToText = stt.SpeechToText();
  }

  Future<void> _loadAllData() async {
    final jamendo = JamendoService();
    try {
      final songsData = await jamendo.fetchPopularTracks();
      final artistsData = await jamendo.fetchPopularArtists();
      final albumsData = await jamendo.fetchPopularAlbums();

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

      final List<Artist> ar = artistsData
          .where((e) => e['image'] != null && e['image'].toString().trim().isNotEmpty)
          .map<Artist>((e) => ArtistModel(
        id: e['id']?.toString() ?? '',
        name: e['name'] ?? 'Unknown',
        avatar: e['image'] ?? '',
      )).toList();

      final List<Album> al = albumsData.map<Album>((e) => AlbumModel(
        id: e['id']?.toString() ?? '',
        albumTitle: e['name'] ?? 'Unknown',
        artistId: e['artist_id']?.toString() ?? '',
        artistName: e['artist_name'] ?? 'Unknown',
        image: e['image'] ?? '',
      )).toList();

      if (mounted) {
        setState(() {
          _allSongs = s;
          _allArtists = ar;
          _allAlbums = al;
          _isLoading = false;
        });
      }
    } catch(e) {
       print("Loi tai trang search: $e");
       if (mounted) setState(() => _isLoading = false);
    }
  }
  void onListen({BuildContext? dialogContext, VoidCallback? onStatusChanged}) async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) {
          if (status == 'notListening' || status == 'done') {
            if (mounted) setState(() => _isListening = false);
            if (onStatusChanged != null) onStatusChanged();
            if (dialogContext != null && Navigator.canPop(dialogContext)) {
              Navigator.pop(dialogContext);
            }
          } else if (status == 'listening') {
            if (mounted) setState(() => _isListening = true);
            if (onStatusChanged != null) onStatusChanged();
          }
        },
        onError: (val) {
          if (mounted) setState(() => _isListening = false);
          if (onStatusChanged != null) onStatusChanged();
          if (dialogContext != null && Navigator.canPop(dialogContext)) {
            Navigator.pop(dialogContext);
          }
        },
      );
      if (available) {
        _speechToText.listen(
          localeId: "vi_VN",
          pauseFor: const Duration(seconds: 5), // Tự động đóng sau 5 giây im lặng
          listenFor: const Duration(seconds: 30), // Giới hạn 30 giây
          onResult: (val) {
            if (mounted) {
              setState(() {
                _searchController.text = val.recognizedWords;
                _searchController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _searchController.text.length),
                );
              });
            }
          },
        );
      }
    } else {
      _speechToText.stop();
      if (mounted) setState(() => _isListening = false);
      if (onStatusChanged != null) onStatusChanged();
      if (dialogContext != null && Navigator.canPop(dialogContext)) {
        Navigator.pop(dialogContext);
      }
    }
  }

  void showSpeechToTextDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        // Tự động lắng nghe ngay khi dialog hiển thị
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_isListening) {
            onListen(dialogContext: dialogContext);
          }
        });

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    AvatarGlow(
                      animate: _isListening,
                      duration: const Duration(milliseconds: 2000),
                      repeat: true,
                      child: Material(
                        elevation: 8.0,
                        shape: const CircleBorder(),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: IconButton(
                            icon: const Icon(
                              Icons.mic,
                              color: Colors.blueAccent,
                              size: 30,
                            ),
                            onPressed: () {
                              onListen(
                                dialogContext: dialogContext,
                                onStatusChanged: () => setDialogState(() {}),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                )
              ),
            );
          }
        );
      }
    );
  }

  void _onSearchChanged() {
    final text = _searchController.text;
    // Debounce history saving
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 2), () {
      if (text.trim().isNotEmpty && mounted) {
        _addToHistory(text);
      }
    });

    setState(() {
      _searchQuery = text.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredSongs = [];
        _filteredArtists = [];
        _filteredAlbums = [];
      } else {
        _filteredSongs = _allSongs
            .where((song) => song.title.toLowerCase().contains(_searchQuery))
            .toList();
        _filteredArtists = _allArtists
            .where((artist) => artist.name.toLowerCase().contains(_searchQuery))
            .toList();
        _filteredAlbums = _allAlbums
            .where((album) => album.albumTitle.toLowerCase().contains(_searchQuery))
            .toList();
      }
    });
  }

  void _addToHistory(String query) {
    if (query.trim().isEmpty) return;
    setState(() {
      _searchHistory.remove(query);
      _searchHistory.insert(0, query);
      if (_searchHistory.length > 10) _searchHistory.removeLast();
    });
  }

  void _removeFromHistory(String query) {
    setState(() {
      _searchHistory.remove(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    TextField(
                      controller: _searchController,
                      style: const TextStyle( fontSize: 16),
                      onSubmitted: _addToHistory,
                      decoration: InputDecoration(
                        hintText: 'Bạn muốn nghe gì?',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => _searchController.clear(),
                            )
                          : IconButton(
                            onPressed: () => showSpeechToTextDialog(),
                            icon: const Icon(Icons.mic)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      _searchQuery.isEmpty ? 'Lịch sử tìm kiếm' : 'Kết quả tìm kiếm',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            if (_searchQuery.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SearchHistory(
                    history: _searchHistory,
                    onSelect: (query) {
                      _searchController.text = query;
                    },
                    onDelete: _removeFromHistory,
                  ),
                ),
              )
            else if (_isLoading)
              const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator(color: Colors.white)),
              )
            else if (_filteredSongs.isEmpty && _filteredArtists.isEmpty && _filteredAlbums.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Không tìm thấy kết quả nào',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              )
            else
              SearchResultsList(
                filteredSongs: _filteredSongs,
                filteredArtists: _filteredArtists,
                filteredAlbums: _filteredAlbums,
                searchQuery: _searchController.text,
                onAddToHistory: _addToHistory,
              ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 100), // Space for mini player/bottom bar
            ),
          ],
        ),
      ),
    );
  }
}