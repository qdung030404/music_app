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
