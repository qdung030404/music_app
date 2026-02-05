import 'package:music_app/domain/entities/playlist_entity.dart';
export 'package:music_app/domain/entities/playlist_entity.dart';

class PlaylistModel extends Playlist {
  PlaylistModel({
    required super.id,
    required super.playlistName,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['id']?.toString() ?? '',
      playlistName: (json['name'] ?? json['playlistName'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': playlistName,
    };
  }
}
