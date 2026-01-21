import '../model/song.dart';
import '../services/source_service.dart';

abstract interface class Repository {
  Future<List<Song>?> loadData();
}

class DefaultRepository implements Repository {
  final _localDataSource = LocalDataSource();
  final _remoteDataSource = RemoteDataSource();

  @override
  Future<List<Song>?> loadData() async {
    List<Song> songs = [];
    await _remoteDataSource.getData().then((remoteSongs) {
      if (remoteSongs == null) {
        _localDataSource.getData().then((localSongs) {
          if (localSongs != null) {
            songs.addAll(localSongs);
          }
        });
      }else{
        songs.addAll(remoteSongs);
      }
    });
    return songs;

  }
}