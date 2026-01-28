class Song {
  String id;
  String title;
  String album;
  /// FK -> artists collection/table
  String artistId;
  /// Denormalized/display value (filled by join or embedded data)
  String? artistName;
  String source;
  String image;
  int duration;

  Song({
    required this.id,
    required this.title,
    required this.album,
    required this.artistId,
    this.artistName,
    required this.source,
    required this.image,
    required this.duration,
  });

  /// Prefer to show name; fallback to id (or empty).
  String get artistDisplay => (artistName?.trim().isNotEmpty ?? false)
      ? artistName!.trim()
      : artistId;

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? '',
      album: json['album'] ?? '',
      // Firestore new schema: artistId
      // Remote JSON old schema: artist (name)
      artistId: json['artistId']?.toString() ?? json['artist']?.toString() ?? '',
      // Optional denormalized name if provided
      artistName: (json['name'] ?? json['artist_name'])?.toString(),
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
          other is Song && runtimeType == other.runtimeType && album == other.album;

  @override
  int get hashCode => album.hashCode;

  @override
  String toString() {
    return 'Song{id: $id, title: $title, album: $album, artistId: $artistId, artistName: $artistName, source: $source, image: $image, duration: $duration}';
  }
}