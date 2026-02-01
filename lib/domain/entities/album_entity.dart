class Album{
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
  String get artistDisplay => (artistName?.trim().isNotEmpty ?? false)
      ? artistName!.trim()
      : artistId;
}