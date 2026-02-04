import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
class Albumplaylist extends StatelessWidget {
  const Albumplaylist({super.key});

  @override
  Widget build(BuildContext context) {
    return AlbumPlaylistView();
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
    super.dispose();
    _tabController.dispose();
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
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(inherit: false, color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(inherit: false, color: Colors.white70, fontSize: 16),
            tabs: const [
              Tab(text: 'Album'),
              Tab(text: 'Playlist')
            ],
          ),
          Expanded(
            child: PageStorage(
                bucket: PageStorageBucket(),
                child: TabBarView(
                  controller: _tabController,
                  children: const[
                    ScrollList(title: 'PlayList', key: PageStorageKey('Playlist')),
                    ScrollList(title: 'Album', key: PageStorageKey('Album')),
                  ]
                )
            ),
          )
        ],
      ),
    );
  }
}
class ScrollList extends StatelessWidget {
  final String title;
  const ScrollList({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

