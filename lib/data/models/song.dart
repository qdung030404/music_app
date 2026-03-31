// Model layer (MVP) — gộp entity + model vào một file
class Song {
  String id;
  String title;
  String albumId;
  String artistId;
  String? albumName;
  String? artistName;
  String source;
  String image;
  int duration;

  Song({
    required this.id,
    required this.title,
    required this.albumId,
    required this.artistId,
    this.albumName,
    this.artistName,
    required this.source,
    required this.image,
    required this.duration,
  });

  String get albumDisplay =>
      (albumName?.trim().isNotEmpty ?? false) ? albumName!.trim() : albumId;

  String get artistDisplay =>
      (artistName?.trim().isNotEmpty ?? false) ? artistName!.trim() : artistId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Song && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Song{id: $id, title: $title, album: $albumId, artistId: $artistId, artistName: $artistName, source: $source, image: $image, duration: $duration}';
  }
}

class SongModel extends Song {
  SongModel({
    required super.id,
    required super.title,
    required super.albumId,
    required super.artistId,
    super.albumName,
    super.artistName,
    required super.source,
    required super.image,
    required super.duration,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? '',
      albumId: json['albumId']?.toString() ?? json['album']?.toString() ?? '',
      artistId:
          json['artistId']?.toString() ?? json['artist']?.toString() ?? '',
      albumName: (json['albumName'] ?? json['album_title'])?.toString(),
      artistName: (json['artistName'] ?? json['artist_name'])?.toString(),
      source: json['source'] ?? '',
      image: json['image'] ?? '',
      duration: json['duration'] is int
          ? json['duration']
          : int.tryParse(json['duration']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'albumId': albumId,
      'artistId': artistId,
      'albumName': albumName,
      'artistName': artistName,
      'source': source,
      'image': image,
      'duration': duration,
    };
  }
}
