import '../../domain/entities/artist_entity.dart';
export '../../domain/entities/artist_entity.dart';

class ArtistModel extends Artist {
  ArtistModel({
    required super.id,
    required super.avatar,
    required super.name,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
        id: json['id']?.toString() ?? '',
        avatar: json['avatar'] ?? '',
        name: json['name'] ?? '');
  }
  
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'avatar': avatar,
      'name': name,
    };
  }
}
