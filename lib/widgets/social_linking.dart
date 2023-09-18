import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sition/services/save_data_service.dart';
import 'package:sition/services/spotify_service.dart';
import 'package:sition/services/youtube_music_service.dart';
import 'package:sition/widgets/social_link.dart';

class socialLinking extends StatefulWidget {
  final dynamic settingsVisibleSetter;
  const socialLinking({
    required this.settingsVisibleSetter,
    Key? key,
  }) : super(key: key);
  @override
  _socialLinkingState createState() => _socialLinkingState();
}

class _socialLinkingState extends State<socialLinking> {
  @override
  bool spotifyConnected = false;
  bool youtubeConnected = false;
  final GetIt getIt = GetIt.instance;
  @override
  void initState() {
    spotifyConnected = getIt<SaveDataService>().hasSpotifyAuthToken();
    youtubeConnected = getIt<SaveDataService>().hasYoutubeAuthToken();
  }

  Widget build(BuildContext context) {
    final GetIt getIt = GetIt.instance;

    closeSettingsPage() {
      widget.settingsVisibleSetter(false);
    }

    loginToSpotify() {
      getIt<SpotifyService>()
          .retrieveSpotifyAuthToken()
          .then((isConnected) => {
                setState(() {
                  spotifyConnected = isConnected;
                })
              })
          .onError((error, stackTrace) {
        print(error);
        throw (error.toString());
      });
    }

    loginToYoutube() {
      getIt<YoutubeMusicService>().loginToYoutube().then((value) => {
            print(value),
            setState(() {
              youtubeConnected = true;
            })
          });
    }

    socialLinkingSetter(String serviceName, bool connectionStatus) {
      switch (serviceName) {
        case "Spotify":
          getIt<SaveDataService>().setSpotifyAuthToken("");
          setState(() {
            spotifyConnected = connectionStatus;
          });
          break;
        case "Youtube":
          getIt<SaveDataService>().setYoutubeAuthToken("");
          setState(() {
            youtubeConnected = connectionStatus;
          });
          break;
      }
    }

    return Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: IconButton(
                      onPressed: () => {closeSettingsPage()},
                      color: Colors.white,
                      icon: Icon(Icons.close)),
                ),
                Text(
                  'Linked accounts',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
              ],
            ),
            socialLink(
                socialLinker: socialLinkingSetter,
                linkingName: "Spotify",
                isLinked: spotifyConnected,
                loginFunction: loginToSpotify),
            socialLink(
                socialLinker: socialLinkingSetter,
                linkingName: "Youtube",
                isLinked: youtubeConnected,
                loginFunction: loginToYoutube)
          ],
        ));
  }
}
