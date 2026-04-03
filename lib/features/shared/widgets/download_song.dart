import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_app/core/services/download_service.dart';
import 'package:music_app/data/models/song.dart';

class DownloadSong extends StatefulWidget {
  final List<Song> songs;

  const DownloadSong({super.key, required this.songs});

  @override
  State<DownloadSong> createState() => _DownloadSongState();
}

class _DownloadSongState extends State<DownloadSong>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Song> _allSongs = [];
  final Set<String> _selectedSongIds = {};
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _allSongs = widget.songs;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startDownload() async {
    if (_selectedSongIds.isEmpty) return;

    setState(() {
      _isDownloading = true;
    });

    // Lấy những bài hát được chọn
    final songsToDownload = _allSongs
        .where((song) => _selectedSongIds.contains(song.id.toString()))
        .toList();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đang tải ${songsToDownload.length} bài hát...')),
    );

    final downloadService = DownloadService();
    await downloadService.downloadMultipleSongs(songsToDownload);

    if (mounted) {
      setState(() {
        _isDownloading = false;
        _selectedSongIds.clear(); // Bỏ chọn sau khi tải xong
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã tải xuống hoàn tất!')),
      );
    }
  }

  void _toggleSong(String songId) {
    setState(() {
      if (_selectedSongIds.contains(songId)) {
        _selectedSongIds.remove(songId); // Nếu đa chọn thì bỏ chọn
      } else {
        _selectedSongIds.add(songId); // Nếu chưa chọn thì thêm vào danh sách
      }
    });
    _controller.forward().then((_) => _controller.reverse());
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectedSongIds.length == _allSongs.length) {
        _selectedSongIds.clear(); // Bỏ chọn tất cả
      } else {
        _selectedSongIds.addAll(
          _allSongs.map((s) => s.id.toString()),
        ); // Chọn tất cả
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tải bài hát',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: _toggleSelectAll,
            child: Text(
              _selectedSongIds.length == _allSongs.length
                  ? 'Bỏ Chọn'
                  : 'Chọn tất cả',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: _allSongs.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _allSongs.length,
              itemBuilder: (context, index) {
                final song = _allSongs[index];
                return DownloadSongCard(
                  song: song,
                  isSelected: _selectedSongIds.contains(song.id.toString()),
                  onTap: () => _toggleSong(song.id.toString()),
                );
              },
            ),
      floatingActionButton: _selectedSongIds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _isDownloading ? null : _startDownload,
              backgroundColor: const Color(0xFF00D9D9),
              icon: _isDownloading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.download, color: Colors.black),
              label: Text(
                _isDownloading
                    ? 'Đang tải...'
                    : 'Tải xuống (${_selectedSongIds.length})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            )
          : null,
    );
  }
}

class DownloadSongCard extends StatelessWidget {
  final Song song;
  final bool isSelected;
  final VoidCallback onTap;

  const DownloadSongCard({
    super.key,
    required this.song,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: isSelected,
      onChanged: (_) => onTap(),
      activeColor: const Color(0xFF00D9D9),
      checkColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      controlAffinity: ListTileControlAffinity.trailing,
      title: Text(
        song.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        song.artistDisplay,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
      secondary: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: song.image.isNotEmpty
            ? FadeInImage.assetNetwork(
                placeholder: 'assets/itunes_256.png',
                image: song.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/itunes_256.png',
                  width: 50,
                  height: 50,
                ),
              )
            : Image.asset(
                'assets/itunes_256.png',
                width: 50,
                height: 50,
              ),
      ),
    );
  }
}
