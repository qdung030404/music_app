import 'package:flutter/material.dart';
import 'package:music_app/data/datasources/user_activity_service.dart';

import '../../../domain/entities/song_entity.dart';
import '../wiget/favorite_song_list.dart';

class FavoriteSong extends StatefulWidget {
  const FavoriteSong({super.key});

  @override
  State<FavoriteSong> createState() => _FavoriteSongState();
}

class _FavoriteSongState extends State<FavoriteSong> {
  late ScrollController _scrollController;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset > 80 && !_showTitle) {
        setState(() {
          _showTitle = true;
        });
      } else if (_scrollController.offset <= 80 && _showTitle) {
        setState(() {
          _showTitle = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: AnimatedOpacity(
          opacity: _showTitle ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: const Text(
            'Yêu thích',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 32,
                ),
                const Center(
                  child: Text(
                    'Yêu thích',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                StreamBuilder<List<Song>>(
                  stream: UserActivityService().getFavoritesStream(),
                  builder: (context, snapshot) {
                    final count = snapshot.data?.length ?? 0;
                    return Center(
                      child: Text(
                        '$count bài hát • đã lưu vào thư viện',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                const FavoriteSongList(),
                const SizedBox(height: 100), // Khoảng trống ở dưới để test cuộn
              ],
            ),
          ),
        ),
      ),
    );
  }
}
