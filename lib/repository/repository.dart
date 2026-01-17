import '../model/song.dart';
import '../services/youtube_service.dart';

abstract interface class Repository {
  Future<List<Song>?> getData();
}

class DefaultRepository implements Repository {
  final _localDataSource = LocalDataSource();
  final _youtubeDataSource = YouTubeDataSource();

  @override
  Future<List<Song>?> getData() async {
    List<Song> songs = [];

    await _youtubeDataSource.getData().then((youtubeSongs) {
      if (youtubeSongs == null) {
        _localDataSource.getData().then((localSongs) {
          if (localSongs != null) {
            songs.addAll(localSongs);
          }
        });
      } else {
        songs.addAll(youtubeSongs);
      }
    });

    return songs;
  }
}