import 'package:flutter/material.dart';
import 'album_page_storage.dart';
import 'playlist_page_storage.dart';

class Albumplaylist extends StatelessWidget {
  const Albumplaylist({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlbumPlaylistView();
  }
}

class AlbumPlaylistView extends StatefulWidget {
  const AlbumPlaylistView({super.key});

  @override
  State<AlbumPlaylistView> createState() => _AlbumPlaylistViewState();
}

class _AlbumPlaylistViewState extends State<AlbumPlaylistView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.deepPurple,
            labelColor: Theme.of(context).textTheme.bodyLarge?.color,
            unselectedLabelColor: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
            labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 16),
            tabs: const [
              Tab(text: 'Playlist'),
              Tab(text: 'Album'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                PlaylistPageStorage(),
                AlbumPageStorage(),
              ],
            ),
          )
        ],
      ),
    );
  }
}


