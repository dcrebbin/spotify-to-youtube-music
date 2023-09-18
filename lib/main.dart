import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:sition/config/constants.dart';
import 'package:sition/services/save_data_service.dart';
import 'package:sition/services/spotify_service.dart';
import 'package:sition/services/youtube_music_service.dart';
import 'package:sition/widgets/playlist_container.dart';
import 'package:sition/widgets/social_linking.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(SpotifyToYoutubeTransfer());
}

class SpotifyToYoutubeTransfer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.APP_TITLE,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  final GetIt getIt = GetIt.instance;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  initState() {
    registerServices();
    loadSaveData();
  }

  bool settingsVisible = false;

  void loadSaveData() {
    widget.getIt<SaveDataService>().loadSavedDate();
  }

  void registerServices() {
    widget.getIt.registerSingleton<SpotifyService>(SpotifyService());
    widget.getIt.registerSingleton<SaveDataService>(SaveDataService());
    widget.getIt.registerSingleton<YoutubeMusicService>(YoutubeMusicService());
  }

  checkMe() {
    widget
        .getIt<SpotifyService>()
        .getSpotifyProfile()
        .then((value) => print(value));
  }

  setSettingsVisibility(bool settingsVisibility) {
    setState(() {
      settingsVisible = settingsVisibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
        appBar: AppBar(
          leading: Container(
            child: Text(
              'sition',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: 20),
            ),
          ),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              iconSize: 30,
              color: Color(0xFF202020),
              onPressed: () => {this.setSettingsVisibility(true)},
              icon: Icon(Icons.account_circle),
            ),
            IconButton(
              iconSize: 30,
              color: Color(0xFF202020),
              onPressed: () => {this.setSettingsVisibility(true)},
              icon: Icon(Icons.account_circle),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    Visibility(
                        visible: settingsVisible,
                        child: socialLinking(
                          settingsVisibleSetter: setSettingsVisibility,
                        )),
                    Visibility(
                        visible: !settingsVisible, child: PlaylistContainer())
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
