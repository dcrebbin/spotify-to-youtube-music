import 'package:flutter/material.dart';
import 'package:sition/models/playlist_item.dart';

class playlistItem extends StatefulWidget {
  final bool playlistOpen;
  final dynamic playlistVisibilitySetter;
  final dynamic playlistItemInput;
  final String playlistType;
  final dynamic selectedPlaylistSetter;
  const playlistItem({
    this.selectedPlaylistSetter,
    required this.playlistItemInput,
    required this.playlistType,
    required this.playlistOpen,
    required this.playlistVisibilitySetter,
    Key? key,
  }) : super(key: key);

  @override
  _playlistItemState createState() => _playlistItemState();
}

class _playlistItemState extends State<playlistItem> {
  late PlaylistItem spotifyPlaylistItem = new PlaylistItem(
      index: 0,
      name: "",
      description: "",
      creator: "",
      id: "",
      imageUri: "",
      totalTracks: 0);

  late dynamic youtubePlaylistItem;
  @override
  void initState() {
    if (widget.playlistType == "spotify") {
      spotifyPlaylistItem = widget.playlistItemInput;
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    void openPlaylist() {
      print('opening playlist');
      if (widget.playlistOpen) {
        widget.playlistVisibilitySetter(false);
        return;
      }
      setState(() {
        widget.selectedPlaylistSetter(spotifyPlaylistItem.index);
      });
      widget.playlistVisibilitySetter(true);
    }

    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 30, right: 30, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: 80,
                        height: 80,
                        child: Image.network(spotifyPlaylistItem.imageUri)),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(spotifyPlaylistItem.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            child: Text('by ${spotifyPlaylistItem.creator}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                          ),
                          Container(
                            child: Text(
                                '${spotifyPlaylistItem.totalTracks.toString()} Tracks',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                    iconSize: 35,
                    color: Colors.white,
                    onPressed: () => {openPlaylist()},
                    icon: Icon(widget.playlistOpen == true
                        ? Icons.arrow_back_ios
                        : Icons.arrow_forward_ios)),
              ],
            ),
            Container(
              width: 200,
              margin: EdgeInsets.only(top: 10),
              child: Text(spotifyPlaylistItem.description,
                  style: TextStyle(color: Colors.white)),
            ),
            Container(
                child: Divider(
              thickness: 0.4,
              color: Colors.white,
              height: 36,
            )),
          ],
        ),
      ),
    );
  }
}
