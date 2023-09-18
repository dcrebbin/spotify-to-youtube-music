class PlaylistItem {
  String name = "";
  String description = "";
  String creator = "";
  String id = "";
  String imageUri = "";
  int totalTracks = 0;
  int index = 0;
  PlaylistItem(
      {required this.name,
      required this.index,
      required this.description,
      required this.creator,
      required this.id,
      required this.imageUri,
      required this.totalTracks});
}
