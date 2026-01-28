import '../model/song.dart';
import '../services/source_service.dart';

abstract interface class Repository {
  Future<List<Song>?> loadData();
}

class DefaultRepository implements Repository {
  final _localDataSource = LocalDataSource();
  final _remoteDataSource = RemoteDataSource();
  final _firestoreDataSource = FirestoreDataSource();

  @override
  Future<List<Song>?> loadData() async {
    try {
      final firestoreSongs = await _firestoreDataSource.getData();
      if (firestoreSongs != null && firestoreSongs.isNotEmpty) {
        return firestoreSongs;
      }

      // Fallback remote JSON
      final remoteSongs = await _remoteDataSource.getData();
      if (remoteSongs != null && remoteSongs.isNotEmpty) {
        return remoteSongs;
      }

      // Fallback local JSON
      return await _localDataSource.getData();
    } catch (e) {
      print('Error loading data: $e');
      return await _localDataSource.getData();
    }
  }
}