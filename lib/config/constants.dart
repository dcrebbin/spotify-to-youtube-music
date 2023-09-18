class Constants {
  static const String APP_TITLE = "Spotify to Youtube Music";

  static const String SPOTIFY_REDIRECT_URI =
      "spotifyToYoutubeTransfer://authToken";
  static const String SPOTIFY_API_SCOPE =
      "app-remote-control,user-modify-playback-state,playlist-read-private";
  static const String SPOTIFY_API_HOST = "api.spotify.com";
  static const String SPOTIFY_API_PROFILE_ENDPOINT = "v1/me";
  static const String SPOTIFY_API_PLAYLISTS_ENDPOINT = "v1/me/playlists";
  static const String SPOTIFY_API_SINGLE_PLAYLIST_ENDPOINT = "v1/playlists/";

  static const String YOUTUBE_API_HOST = "youtube.googleapis.com";
  static const String YOUTUBE_API_ADD_VIDEO_TO_PLAYLIST_ENDPOINT =
      "youtube/v3/playlistItems";
}
