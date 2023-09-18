import 'package:flutter/material.dart';
import 'package:sition/models/playlist_item.dart';
import 'package:sition/models/playlist_track.dart';
import 'package:sition/widgets/playlist_item.dart';

class ConversionDialog extends StatefulWidget {
  final PlaylistItem selectedPlaylist;
  const ConversionDialog({
    required this.selectedPlaylist,
    Key? key,
  }) : super(key: key);

  @override
  _ConversionDialogState createState() => _ConversionDialogState();
}

class _ConversionDialogState extends State<ConversionDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      child: Container(
        height: 200,
        width: 400,
        child: playlistItem(
          playlistItemInput: widget.selectedPlaylist,
          playlistType: "spotify",
          playlistVisibilitySetter: '',
          playlistOpen: true,
        ),
      ),
    );
  }
}
