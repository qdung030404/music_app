import 'package:music_app/domain/entities/playlist_entity.dart';

export 'package:music_app/domain/entities/playlist_entity.dart';

class PlaylistModel extends Playlist {
  PlaylistModel({
    required super.id,
    required super.playlistName,
    super.image,
    super.creatorName,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['id']?.toString() ?? '',
      playlistName: (json['name'] ?? json['playlistName'] ?? '').toString(),
      image: json['image']?.toString(),
      creatorName: (json['user_name'] ?? json['by'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': playlistName,
      'image': image,
      'by': creatorName,
    };
  }
}
