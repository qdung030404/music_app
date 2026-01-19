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
    final youtubeSongs = await _youtubeDataSource.getData();

    if (youtubeSongs != null) {
      return youtubeSongs;
    }

    return await _localDataSource.getData();
  }
}