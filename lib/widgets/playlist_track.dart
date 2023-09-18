import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sition/models/playlist_item.dart';
import 'package:sition/models/playlist_track.dart';

class playlistTrack extends StatelessWidget {
  final PlaylistTrack track;
  const playlistTrack({
    required this.track,
    Key? key,
  }) : super(key: key);

  String shortenTrackName(String trackName) {
    if (trackName.length > 19) {
      return trackName.substring(0, 19) + "...";
    }
    return trackName;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30, top: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(shortenTrackName(track.name),
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    child: Text(track.artist,
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                ],
              ),
              Container(
                  width: 90, height: 90, child: Image.network(track.imageUri)),
            ],
          ),
          Container(
              child: Divider(
            thickness: 0.4,
            color: Colors.white,
            height: 36,
          )),
        ],
      ),
    );
  }
}
