import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music_app/domain/entities/song_entity.dart';
import 'package:music_app/domain/entities/artist_entity.dart';
import 'package:music_app/domain/entities/album_entity.dart';
import 'package:music_app/domain/usecases/get_songs.dart';
import 'package:music_app/domain/usecases/get_artists.dart';
import 'package:music_app/domain/usecases/get_album.dart';
import 'package:music_app/data/repository/song_repository.dart';
import 'package:music_app/data/repository/artist_repository.dart';
import 'package:music_app/data/repository/album_repository.dart';
import '../widget/search_results_list.dart';
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
    final getSongs = GetSongs(SongRepositoryImpl());
    final getArtists = GetArtists(ArtistRepositoryImpl());
    final getAlbums = GetAlbums(AlbumRepositoryImp());

    final songs = await getSongs();
    final artists = await getArtists();
    final albums = await getAlbums();

    if (mounted) {
      setState(() {
        _allSongs = songs ?? [];
        _allArtists = artists;
        _allAlbums = albums;
        _isLoading = false;
      });
    }
  }
  void onListen({BuildContext? dialogContext}) async {
    if (!_isListening) {
      var locales = await _speechToText.locales();
      bool available = await _speechToText.initialize(
        onStatus: (status) {
          if (status == 'notListening' || status == 'done') {
            setState(() => _isListening = false);
            if (dialogContext != null && Navigator.canPop(dialogContext)) {
              Navigator.pop(dialogContext);
            }
          } else if (status == 'listening') {
            setState(() => _isListening = true);
          }
        },
        onError: (val) {
          setState(() => _isListening = false);
          if (dialogContext != null && Navigator.canPop(dialogContext)) {
            Navigator.pop(dialogContext);
          }
        },
      );
      if (available) {
        _speechToText.listen(
          localeId: "vi_VN",
          onResult: (val) {
            setState(() {
              _searchController.text = val.recognizedWords;
              _searchController.selection = TextSelection.fromPosition(
                TextPosition(offset: _searchController.text.length),
              );
            });
          },
        );
      }
    } else {
      _speechToText.stop();
      setState(() => _isListening = false);
    }

  }

  void showSpeechToTextDialog() {
    onListen();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
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
                          icon: Icon(
                            _isListening ? Icons.stop : Icons.mic,
                            color: Colors.blueAccent,
                            size: 30,
                          ),
                          onPressed: () {
                            onListen(dialogContext: dialogContext);
                            setDialogState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    _isListening ? "Đang lắng nghe..." : "Nhấn mic để nói",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              )
            ),
          );
        }
      )
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF06A0B5), Colors.black],
          stops: [0.01, 0.15],
        ),
      ),
      child: Scaffold(
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
                      const Text(
                        'Tìm kiếm',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.black, fontSize: 16),
                          onSubmitted: _addToHistory,
                          decoration: InputDecoration(
                            hintText: 'Bạn muốn nghe gì?',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(Icons.search, color: Colors.black),
                            suffixIcon: _searchQuery.isNotEmpty 
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: Colors.black),
                                  onPressed: () => _searchController.clear(),
                                )
                              : IconButton(
                                onPressed: () => showSpeechToTextDialog(),
                                icon: const Icon(Icons.mic, color: Colors.black,)),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        _searchQuery.isEmpty ? 'Lịch sử tìm kiếm' : 'Kết quả tìm kiếm',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                    child: _searchHistory.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Lịch sử tìm kiếm trống',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _searchHistory.map((query) {
                              return InputChip(
                                label: Text(query),
                                onDeleted: () => _removeFromHistory(query),
                                deleteIconColor: Colors.black,
                                backgroundColor: Colors.white10,
                                labelStyle: const TextStyle(color: Colors.black),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(color: Colors.white24),
                                ),
                                onPressed: () {
                                  _searchController.text = query;
                                },
                              );
                            }).toList(),
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
      ),
    );
  }
}