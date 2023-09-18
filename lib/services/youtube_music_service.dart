import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:injectable/injectable.dart';
import 'package:sition/config/constants.dart';
import 'package:sition/models/playlist_track.dart';
import 'package:sition/services/save_data_service.dart';
import 'package:sition/yt_login_generator.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:yt/yt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@lazySingleton
class YoutubeMusicService {
  String? youtubeApiKey = dotenv.env['YOUTUBE_API_KEY'];
  final GetIt getIt = GetIt.instance;

  Future<PlaylistTrack?> retrieveYoutubeTrackByQuery(String query) async {
    if (!isAuthenticated()) {
      throw ("Unauthorized");
    }
    YoutubeAPI ytApi = new YoutubeAPI(youtubeApiKey.toString());
    List<YouTubeVideo> response =
        await ytApi.search(query, type: "video", order: "relevance");
    YouTubeVideo retrievedYoutubeTrack = response[0];
    PlaylistTrack playlistTrack = assignPlaylistTrack(retrievedYoutubeTrack);
    return playlistTrack;
  }

  PlaylistTrack assignPlaylistTrack(retrievedYoutubeTrack) {
    PlaylistTrack playlistTrack = PlaylistTrack(
        name: retrievedYoutubeTrack.title,
        artist: retrievedYoutubeTrack.channelTitle,
        id: retrievedYoutubeTrack.id.toString(),
        imageUri: retrievedYoutubeTrack.thumbnail.small.url.toString());
    return playlistTrack;
  }

  Future<bool> loginToYoutube() async {
    Token tokenResponse = await YtLoginGenerator().generate();
    String youtubeAuthToken = tokenResponse.accessToken;
    await getIt<SaveDataService>().setYoutubeAuthToken(youtubeAuthToken);
    return youtubeAuthToken.isNotEmpty;
  }

  bool isAuthenticated() {
    return getIt<SaveDataService>().hasYoutubeAuthToken();
  }

  Future<http.Response> addYoutubeVideoToPlaylist(
      String videoId, String playlistId, int index) async {
    if (!isAuthenticated()) {
      return new http.Response("Unauthorized", HttpStatus.forbidden);
    }
    Uri uri = Uri.https(Constants.YOUTUBE_API_HOST,
        Constants.YOUTUBE_API_ADD_VIDEO_TO_PLAYLIST_ENDPOINT, {
      "part": "snippet",
      "key": youtubeApiKey,
    });
    Map<String, Map<String, Object>> constructedBody = {
      "snippet": {
        "playlistId": playlistId,
        "position": index,
        "resourceId": {"kind": "youtube#video", "videoId": videoId},
      }
    };

    var body = convert.jsonEncode(constructedBody);
    String youtubeAuthToken = getIt<SaveDataService>().youtubeAuthToken;
    http.Response response = await http.post(uri,
        headers: {
          "Authorization": "Bearer " + youtubeAuthToken,
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: convert.jsonEncode(constructedBody));

    return response;
  }
}
