// Model layer (MVP) — gộp entity + model vào một file
class Artist {
  final String id;
  final String avatar;
  final String name;

  const Artist({
    required this.id,
    required this.avatar,
    required this.name,
  });
}

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
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'name': name,
    };
  }
}
