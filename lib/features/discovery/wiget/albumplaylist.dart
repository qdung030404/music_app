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
              Tab(text: 'Playlist'),
              Tab(text: 'Album'),

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
    return Column(
      children: [
        const SizedBox(height: 8),
        GestureDetector(
          onTap: (){ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tính năng thêm nghệ sĩ đang được phát triển')),
          );},
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 12,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(8)
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.add, color: Colors.white, size: 48),
              ),
              SizedBox(width: 16,),
              Text('Thêm playlist',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        )
      ],
    );
  }
}

