import '../../domain/entities/song_entity.dart';
export '../../domain/entities/song_entity.dart';

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
      artistId: json['artistId']?.toString() ?? json['artist']?.toString() ?? '',
      albumName: (json['albumName'] ?? json['album_title'])?.toString(),
      artistName: (json['artistName'] ?? json['artist_name'])?.toString(),
      source: json['source'] ?? '',
      image: json['image'] ?? '',
      duration: json['duration'] is int
          ? json['duration']
          : int.tryParse(json['duration']?.toString() ?? '0') ?? 0,
    );
  }
}