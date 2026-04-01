
class Album {
  String id;
  String artistId;
  String image;
  String? artistName;
  String albumTitle;

  Album({
    required this.id,
    required this.artistId,
    required this.image,
    this.artistName,
    required this.albumTitle,
  });

  String get artistDisplay =>
      (artistName?.trim().isNotEmpty ?? false) ? artistName!.trim() : artistId;
}

class AlbumModel extends Album {
  AlbumModel({
    required super.id,
    required super.artistId,
    required super.image,
    required super.albumTitle,
    super.artistName,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      id: json['id']?.toString() ?? '',
      artistId: json['artistId']?.toString() ?? '',
      image: json['image'] ?? '',
      albumTitle: json['title'] ?? '',
      artistName:
          (json['artistName'] ?? json['artist_name'] ?? json['artistname'])
              ?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'artistId': artistId,
      'image': image,
      'title': albumTitle,
      'artistName': artistName,
    };
  }
}
