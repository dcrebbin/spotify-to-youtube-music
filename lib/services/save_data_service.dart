import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class SaveDataService {
  String youtubeAuthToken = "";
  String spotifyAuthToken = "";

  loadSavedDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    spotifyAuthToken = prefs.getString("spotify_auth_token").toString();
    youtubeAuthToken = prefs.getString("youtube_auth_token").toString();
  }

  setYoutubeAuthToken(String generatedYoutubeAuthToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    youtubeAuthToken = generatedYoutubeAuthToken;
    prefs.setString("youtube_auth_token", youtubeAuthToken);
  }

  setSpotifyAuthToken(String generatedSpotifyAuthToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    spotifyAuthToken = generatedSpotifyAuthToken;
    prefs.setString("spotify_auth_token", spotifyAuthToken);
  }

  bool hasYoutubeAuthToken() {
    return youtubeAuthToken != "";
  }

  bool hasSpotifyAuthToken() {
    return spotifyAuthToken != "";
  }
}
