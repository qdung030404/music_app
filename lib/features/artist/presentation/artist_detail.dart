import 'package:flutter/material.dart';
import 'package:music_app/domain/entities/artist_entity.dart';
import '../../song_detail/presentation/song_detail.dart';
import '../widget/artist_header.dart';
import '../../widget/song_list.dart';
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
  late ScrollController _scrollController;
  late ArtistDetailViewModel _viewModel;
  List<Song> artistSongs = [];
  List<Album> artistAlbums = [];
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _viewModel = ArtistDetailViewModel(artistId: widget.artist.id);
    _viewModel.loadArtistData();
    _observeData();
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: AnimatedOpacity(
          opacity: _showTitle ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Text(
            widget.artist.name,
            style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold),
          ),
      ),
      leading: IconButton(
        icon:Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
            onPressed: (){},
            icon: Icon(Icons.more_horiz)
        )
      ],
    ),
    body: SafeArea(
        child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                ArtistHeader(
                  artist: widget.artist,
                  onPlayAll: (){
                    final randomSongs = List<Song>.from(artistSongs)..shuffle();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SongDetail(
                          songs: randomSongs,
                          playingSong: randomSongs[0],
                        ),
                      ),
                    );
                  }
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
