import 'package:music_app/data/datasources/user_activity_service.dart';
import 'package:music_app/data/model/song.dart';

class FavoriteManager {
  final _userActivityService = UserActivityService();

  Future<bool> checkIsFavorite(String songId) async {
    return await _userActivityService.isFavorite(songId, 'favorites');
  }

  Future<void> toggleFavorite(Song song, bool currentState) async {
    if (currentState) {
      await _userActivityService.removeItem(song.id, 'favorites');
    } else {
      await _userActivityService.addToFavorite(song);
    }
  }
}