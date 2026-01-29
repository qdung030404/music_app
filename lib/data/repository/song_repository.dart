import '../model/song.dart';
import '../datasources/song_local_data_source.dart';
import '../datasources/song_firestore_data_source.dart';

import '../../domain/repositories/song_repository.dart';
import '../../domain/entities/song_entity.dart';

class SongRepositoryImpl implements SongRepository {
  final _localDataSource = SongLocalDataSource();
  final _firestoreDataSource = SongFirestoreDataSource();

  @override
  Future<List<Song>?> getSongs() async {
    try {
      final firestoreSongs = await _firestoreDataSource.getData();
      if (firestoreSongs != null && firestoreSongs.isNotEmpty) {
        return firestoreSongs;
      }

      // Fallback local JSON
      return await _localDataSource.getData();
    } catch (e) {
      print('Error loading data: $e');
      return await _localDataSource.getData();
    }
  }
}