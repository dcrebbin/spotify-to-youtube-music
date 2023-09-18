import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:sition/models/playlist_item.dart';
import 'package:sition/models/playlist_track.dart';
import 'package:sition/services/spotify_service.dart';
import 'package:sition/services/youtube_music_service.dart';
import 'package:sition/widgets/playlist_item.dart';
import 'package:sition/widgets/playlist_track.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlaylistContainer extends StatefulWidget {
  const PlaylistContainer({
    Key? key,
  }) : super(key: key);

  @override
  PlaylistContainerState createState() => PlaylistContainerState();
}

class PlaylistContainerState extends State<PlaylistContainer> {
  final GetIt getIt = GetIt.instance;
  List<PlaylistTrack> youtubeMusicTracks =
      List<PlaylistTrack>.empty(growable: true);

  List<PlaylistItem> spotifyPlaylists =
      List<PlaylistItem>.empty(growable: true);

  List<PlaylistTrack> spotifyMusicTracks =
      List<PlaylistTrack>.empty(growable: true);

  bool conversionInProgress = true;
  bool conversionOpen = false;

  bool playlistOpen = false;
  int lastSelectedPlaylistIndex = 0;

  void convertSpotifyPlaylistToYoutubeMusic() async {
    setState(() {
      conversionInProgress = true;
      conversionOpen = true;
      youtubeMusicTracks = List<PlaylistTrack>.empty(growable: true);
    });
    for (var index = 0; index < spotifyMusicTracks.length; index++) {
      PlaylistTrack spotifyTrack = spotifyMusicTracks[index];
      var constructedQuery = "${spotifyTrack.name} - ${spotifyTrack.artist}";
      await searchVideosByQuery(constructedQuery);
    }
    setState(() {
      conversionInProgress = false;
    });
    print(youtubeMusicTracks);
  }

  Future<void> searchVideosByQuery(String query) async {
    await getIt<YoutubeMusicService>()
        .retrieveYoutubeTrackByQuery(query)
        .then((value) {
      setState(() {
        youtubeMusicTracks.add(value!);
      });
    });
  }

  addVideosToPlaylist() async {
    if (youtubeMusicTracks.length == 0) {
      return;
    }
    var testingPlaylistId = dotenv.env['YOUTUBE_TESTING_PLAYLIST_ID'];
    for (var index = 0; index < youtubeMusicTracks.length; index++) {
      String videoId = youtubeMusicTracks[index].id;
      print("Adding ${youtubeMusicTracks[index].name} to playlist");
      await addVideoToPlaylist(videoId, testingPlaylistId, index);
    }
    await Fluttertoast.showToast(
        msg: "Playlist Created",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
    setState(() {
      resetTrackPlaylists();
      playlistOpen = false;
    });
  }

  Future<bool> addVideoToPlaylist(
      String videoId, String playlistId, int index) async {
    await getIt<YoutubeMusicService>()
        .addYoutubeVideoToPlaylist(videoId, playlistId, index)
        .then((value) {
      print(value.statusCode);
    });
    return true;
  }

  getSpotifyPlaylists() {
    getIt<SpotifyService>().retrieveSpotifyPlaylists().then((value) {
      print(value);
      setState(() {
        spotifyPlaylists = value!;
      });
    });
  }

  resetTrackPlaylists() {
    setState(() {
      conversionOpen = false;
      spotifyMusicTracks = List<PlaylistTrack>.empty(growable: true);
      youtubeMusicTracks = List<PlaylistTrack>.empty(growable: true);
    });
  }

  setPlaylistVisibility(bool playlistVisibility) {
    resetTrackPlaylists();
    setState(() {
      playlistOpen = playlistVisibility;
    });
  }

  getASingleSpotifyPlaylist(String playlistId) {
    getIt<SpotifyService>()
        .retrieveSingleSpotifyPlaylist(playlistId)
        .then((retrievedSpotifyTracks) {
      print('retrievedSpotifyTracks');
      setState(() {
        spotifyMusicTracks = retrievedSpotifyTracks!;
      });
    });
  }

  selectPlaylist(int selectedIndexInput) {
    setState(() {
      lastSelectedPlaylistIndex = selectedIndexInput;
    });
    getASingleSpotifyPlaylist(spotifyPlaylists[lastSelectedPlaylistIndex].id);
  }

  void playlistSelected() {
    print("playlist selected");
  }

  void closeConversion() {
    setState(() {
      conversionOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              'Playlists',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 90,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: TextButton(
                      onPressed: () => {getSpotifyPlaylists()},
                      child: Text('Spotify',
                          style: TextStyle(fontSize: 15, color: Colors.black))),
                ),
                Container(
                  width: 90,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Color(0xFF202020),
                      border: Border.all(
                        color: Color(0xFF202020),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: TextButton(
                      onPressed: () => {},
                      child: Text('Youtube',
                          style: TextStyle(fontSize: 15, color: Colors.white))),
                ),
              ],
            ),
          ),
          Visibility(
            visible: playlistOpen,
            child: Container(
              child: Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      child: playlistItem(
                        playlistItemInput: spotifyPlaylists.length > 0
                            ? spotifyPlaylists[lastSelectedPlaylistIndex]
                            : "",
                        playlistType: "spotify",
                        playlistVisibilitySetter: setPlaylistVisibility,
                        playlistOpen: true,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                Visibility(
                                  visible:
                                      conversionOpen & !conversionInProgress,
                                  child: Container(
                                      child: MaterialButton(
                                    onPressed: () => {addVideosToPlaylist()},
                                    child: Container(
                                      height: 35,
                                      width: 170,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2))),
                                      child: Center(
                                        child: Text('SAVE TO PLAYLIST',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15)),
                                      ),
                                    ),
                                  )),
                                ),
                                Visibility(
                                  visible: !conversionOpen,
                                  child: Container(
                                      child: MaterialButton(
                                    onPressed: () => {
                                      convertSpotifyPlaylistToYoutubeMusic()
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2))),
                                      child: Center(
                                        child: Text('CONVERT',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15)),
                                      ),
                                    ),
                                  )),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: conversionOpen,
                              child: Container(
                                child: IconButton(
                                  iconSize: 30,
                                  color: Colors.white,
                                  onPressed: () => {closeConversion()},
                                  icon: Icon(Icons.arrow_drop_down),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !conversionOpen,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(left: 30, right: 30, top: 15),
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Spotify Playlist',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            height: 340,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: spotifyMusicTracks.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return playlistTrack(
                                      track: spotifyMusicTracks[index]);
                                }),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: conversionOpen,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(left: 30, right: 30, top: 15),
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Youtube Playlist',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            height: 340,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: youtubeMusicTracks.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return playlistTrack(
                                      track: youtubeMusicTracks[index]);
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: !playlistOpen,
            child: Container(
              height: 570,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: spotifyPlaylists.length,
                  itemBuilder: (BuildContext context, int index) {
                    return playlistItem(
                      selectedPlaylistSetter: selectPlaylist,
                      playlistItemInput: spotifyPlaylists[index],
                      playlistType: "spotify",
                      playlistVisibilitySetter: setPlaylistVisibility,
                      playlistOpen: false,
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
