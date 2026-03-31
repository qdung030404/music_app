// Model layer (MVP) — gộp entity + model vào một file
class Playlist {
  final String id;
  final String playlistName;
  final String? image;
  final String? creatorName;
  final bool isPrivate;

  Playlist({
    required this.id,
    required this.playlistName,
    this.image,
    this.creatorName,
    this.isPrivate = true,
  });
}

class PlaylistModel extends Playlist {
  PlaylistModel({
    required super.id,
    required super.playlistName,
    super.image,
    super.creatorName,
    super.isPrivate = true,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['id']?.toString() ?? '',
      playlistName: (json['name'] ?? json['playlistName'] ?? '').toString(),
      image: json['image']?.toString(),
      creatorName: (json['user_name'] ?? json['by'] ?? '').toString(),
      isPrivate: json['isPrivate'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': playlistName,
      'image': image,
      'by': creatorName,
      'isPrivate': isPrivate,
    };
  }
}
