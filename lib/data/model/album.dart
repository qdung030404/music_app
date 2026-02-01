import 'package:music_app/domain/entities/album_entity.dart';
export 'package:music_app/domain/entities/album_entity.dart';

class AlbumModel extends Album{
  AlbumModel({
    required super.id,
    required super.artistId,
    required super.image,
    required super.albumTitle,
    super.artistName,
  });
  factory AlbumModel.fromJson(Map<String, dynamic> json){
    return AlbumModel(
      id: json['id']?.toString() ?? '',
      artistId: json['artistId']?.toString() ?? '',
      image: json['image'] ?? '',
      albumTitle: json['title'] ?? '',
      artistName: (json['artistName'] ?? json['artist_name'])?.toString(),
    );
  }
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'artistId': artistId,
      'image': image,
      'title': albumTitle,
      'artistName': artistName,
    };
  }
}