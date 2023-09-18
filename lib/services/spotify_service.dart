import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:injectable/injectable.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:sition/config/constants.dart';
import 'package:sition/models/playlist_item.dart';
import 'package:sition/models/playlist_track.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:sition/services/save_data_service.dart';

@lazySingleton
class SpotifyService {
  String userId = "";
  var unescape = HtmlUnescape();
  final GetIt getIt = GetIt.instance;

  Future<bool> retrieveSpotifyAuthToken() async {
    String spotifyAuthToken = await SpotifySdk.getAuthenticationToken(
        clientId: dotenv.env['SPOTIFY_API_CLIENT_KEY'].toString(),
        redirectUrl: Constants.SPOTIFY_REDIRECT_URI,
        scope: Constants.SPOTIFY_API_SCOPE);
    await getIt<SaveDataService>().setSpotifyAuthToken(spotifyAuthToken);
    return spotifyAuthToken != "";
  }

  bool authenticated() {
    return getIt<SaveDataService>().hasSpotifyAuthToken();
  }

  Future<dynamic> getSpotifyProfile() async {
    if (!authenticated()) {
      throw ("Unauthorized");
    }
    String spotifyAuthToken = getIt<SaveDataService>().spotifyAuthToken;
    Uri uri = Uri.https(
        Constants.SPOTIFY_API_HOST, Constants.SPOTIFY_API_PROFILE_ENDPOINT);
    http.Response response = await http
        .get(uri, headers: {"Authorization": "Bearer " + spotifyAuthToken});
    dynamic responseBodyObject = convert.jsonDecode(response.body);
    userId = responseBodyObject["id"];
    return responseBodyObject;
  }

  Future<List<PlaylistTrack>?> retrieveSingleSpotifyPlaylist(
      String playlistId) async {
    if (!authenticated()) {
      throw ("Unauthorized");
    }
    String spotifyAuthToken = getIt<SaveDataService>().spotifyAuthToken;

    Uri uri = Uri.https(Constants.SPOTIFY_API_HOST,
        Constants.SPOTIFY_API_SINGLE_PLAYLIST_ENDPOINT + playlistId);
    http.Response response = await http
        .get(uri, headers: {"Authorization": "Bearer " + spotifyAuthToken});
    dynamic responseBodyObject = convert.jsonDecode(response.body);

    List<PlaylistTrack> trackList = List<PlaylistTrack>.empty(growable: true);
    List<dynamic> responsePlaylist = responseBodyObject["tracks"]["items"];

    responsePlaylist.forEach((playlistElement) {
      PlaylistTrack track = assignPlaylistTrack(playlistElement);
      trackList.add(track);
    });
    return trackList;
  }

  PlaylistTrack assignPlaylistTrack(playlistElement) {
    PlaylistTrack track = PlaylistTrack(
        name: playlistElement["track"]["name"],
        artist: "",
        id: playlistElement["track"]["id"],
        imageUri: playlistElement["track"]["album"]["images"][2]["url"]);

    List<dynamic> artists = playlistElement["track"]["artists"];
    List<String> addedArtists = List<String>.empty(growable: true);
    artists.forEach((element) {
      addedArtists.add(element["name"]);
    });
    track.artist = addedArtists.join(', ');
    return track;
  }

  Future<List<PlaylistItem>?> retrieveSpotifyPlaylists() async {
    if (!authenticated()) {
      throw ("Unauthorized");
    }
    String spotifyAuthToken = getIt<SaveDataService>().spotifyAuthToken;

    Uri uri = Uri.https(
        Constants.SPOTIFY_API_HOST, Constants.SPOTIFY_API_PLAYLISTS_ENDPOINT);
    http.Response response = await http
        .get(uri, headers: {"Authorization": "Bearer " + spotifyAuthToken});

    dynamic responseBodyObject = convert.jsonDecode(response.body);
    List<PlaylistItem> playlists = List<PlaylistItem>.empty(growable: true);
    List<dynamic> responsePlaylist = responseBodyObject["items"];
    for (int index = 0; index < responsePlaylist.length; index++) {
      PlaylistItem playlistItem = assignPlaylistItem(responsePlaylist[index]);
      playlistItem.index = index;
      playlists.add(playlistItem);
    }
    return playlists;
  }

  PlaylistItem assignPlaylistItem(playlistElement) {
    PlaylistItem playlistItem = PlaylistItem(
        index: 0,
        name: playlistElement["name"],
        description: unescape.convert(playlistElement["description"]),
        creator: unescape.convert(playlistElement["owner"]["display_name"]),
        id: playlistElement["id"],
        imageUri: playlistElement["images"][0]["url"],
        totalTracks: playlistElement["tracks"]["total"]);
    return playlistItem;
  }
}
