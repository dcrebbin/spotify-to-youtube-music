import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sition/services/save_data_service.dart';
import 'package:yt/yt.dart';

class YtLoginGenerator {
  final GetIt getIt = GetIt.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    signInOption: SignInOption.standard,
    scopes: [
      'https://www.googleapis.com/auth/youtube',
    ],
  );

  @override
  Future<Token> generate() async {
    var _currentUser = null;
    try {
      _currentUser = await _googleSignIn.signIn();
    } catch (e) {
      print(e);
    }
    try {
      if (_currentUser == null) _currentUser = await _googleSignIn.signIn();
    } catch (e) {
      print(e);
    }
    if (_currentUser == null) {
      throw ({null});
    }
    final token = (await _currentUser!.authentication).accessToken;

    if (token == null) throw Exception();
    await getIt<SaveDataService>().setYoutubeAuthToken(token);
    return Token(accessToken: token, expiresIn: 3599, tokenType: '');
  }
}
