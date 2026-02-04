import 'package:flutter/material.dart';
import 'package:music_app/domain/entities/artist_entity.dart';
import '../widget/artist_header.dart';
import '../widget/song_list.dart';
import '../viewmodels/artist_detail_view_model.dart';
import 'package:music_app/domain/entities/song_entity.dart';
import 'package:music_app/domain/entities/album_entity.dart';
import '../../home/widget/album.dart';

class ArtistDetail extends StatelessWidget {
  final Artist artist;
  const ArtistDetail({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return ArtistDetailState(artist: artist);
  }
}
class ArtistDetailState extends StatefulWidget {
  final Artist artist;
  const ArtistDetailState({super.key, required this.artist});

  @override
  State<ArtistDetailState> createState() => _ArtistDetailStateState();
}

class _ArtistDetailStateState extends State<ArtistDetailState> {
  late ArtistDetailViewModel _viewModel;
  List<Song> artistSongs = [];
  List<Album> artistAlbums = [];

  @override
  void initState() {
    super.initState();
    _viewModel = ArtistDetailViewModel(artistId: widget.artist.id);
    _viewModel.loadArtistData();
    _observeData();
  }

  void _observeData() {
    _viewModel.songsController.stream.listen((songs) {
      if (mounted) {
        setState(() {
          artistSongs = songs;
        });
      }
    });
    _viewModel.albumsController.stream.listen((albums) {
      if (mounted) {
        setState(() {
          artistAlbums = albums;
        });
      }
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.black,
      actions: [
        IconButton(
            onPressed: (){},
            icon: Icon(Icons.more_horiz, color: Colors.white)
        )
      ],
    ),
    body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                ArtistHeader(
                  artist: widget.artist,
                ),
                SongList(
                  songs: artistSongs,
                  title: 'Bài hát nổi bật',
                ),
                if (artistAlbums.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: BuildMediaCardList(albums: artistAlbums),
                  ),
                const SizedBox(height: 80),
                ]
            )
        )
    )
    );
  }
}
