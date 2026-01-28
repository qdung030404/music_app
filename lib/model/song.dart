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

  String get albumDisplay => (albumName?.trim().isNotEmpty ?? false)
      ? albumName!.trim()
      : albumId;
  String get artistDisplay => (artistName?.trim().isNotEmpty ?? false)
      ? artistName!.trim()
      : artistId;

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
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