import 'package:flutter/material.dart';
import 'package:music_app/domain/entities/song_entity.dart';
import 'package:music_app/domain/entities/artist_entity.dart';
import 'package:music_app/domain/entities/album_entity.dart';
import 'package:music_app/features/widget/song_card.dart';
import '../../album/presentation/album_detail.dart';
import '../../artist/presentation/artist_detail.dart';

class SearchResultsList extends StatelessWidget {
  final List<Song> filteredSongs;
  final List<Artist> filteredArtists;
  final List<Album> filteredAlbums;
  final String searchQuery;
  final Function(String) onAddToHistory;

  const SearchResultsList({
    super.key,
    required this.filteredSongs,
    required this.filteredArtists,
    required this.filteredAlbums,
    required this.searchQuery,
    required this.onAddToHistory,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        if (filteredSongs.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "Bài hát",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...filteredSongs.map((song) => GestureDetector(
            onTapDown: (_) => onAddToHistory(searchQuery),
            child: SongCard(song: song, songs: filteredSongs),
          )),
          const SizedBox(height: 16),
        ],
        if (filteredArtists.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "Nghệ sĩ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredArtists.length,
              itemBuilder: (context, index) {
                final artist = filteredArtists[index];
                return GestureDetector(
                  onTap: () {
                    onAddToHistory(searchQuery);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArtistDetail(artist: artist),
                      ),
                    );
                  },
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(artist.avatar),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          artist.name,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (filteredAlbums.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "Album",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredAlbums.length,
              itemBuilder: (context, index) {
                final album = filteredAlbums[index];
                return GestureDetector(
                  onTap: () {
                    onAddToHistory(searchQuery);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlbumDetail(album: album),
                      ),
                    );
                  },
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            album.image,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          album.albumTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ]),
    );
  }
}
