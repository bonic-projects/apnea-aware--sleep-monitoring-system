import 'package:apnea_aware/app/app.locator.dart';
import 'package:apnea_aware/app/app.logger.dart';
import 'package:apnea_aware/models/appuser.dart';
import 'package:apnea_aware/services/firestore_service.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

class UserService {
  final log = getLogger('UserService');
  final _authenticationService = locator<FirebaseAuthenticationService>();
  final _firestoreService = locator<FirestoreService>();

  bool get hasLoggedInUser => _authenticationService.hasUser;

  AppUser? _user;
  AppUser? get user => _user;

  void logout() {
    _user = null;
    _authenticationService.logout();
  }

  void deleteVideoId() async {
    await _firestoreService.deleteVideoId();
  }

  Future<String?> createUpdateUser(AppUser user) async {
    bool value = await _firestoreService.createUser(
      user: user,
      keyword: _createKeyWords(user.fullName),
    );
    if (!value) {
      return "Error uploading data";
    } else {
      return null;
    }
  }

  Future<String?> updateUser(AppUser user) async {
    await _firestoreService.updateVideoId(videoId: user.videoId.toString());
    return null;
  }

  Future<AppUser?> fetchUser() async {
    final uid = _authenticationService.currentUser?.uid;
    if (uid != null) {
      AppUser? user = await _firestoreService.getUser(userId: uid);
      if (user != null) {
        _user = user;
        _user = user;
      }
    }
    return _user;
  }

  List<AppUser?> get idUser => _idUser;
  late List<AppUser?> _idUser;

  Future<List<AppUser?>?> fetchVideoIdUser() async {
    try {
      List<AppUser>? idUser = await _firestoreService.getUsersWithVideoId();
      if (idUser.isNotEmpty) {
        _idUser = idUser.toList();
      }
      return _idUser;
    } catch (e) {
      log.e("Error fetching video ID user: $e");
      return null;
    }
  }

  ///keywords list creating function
  List<String> _createKeyWords(String text) {
    text = text.toLowerCase();
    List<String> keywords = [];
    for (int i = 0; i <= text.length; i++) {
      if (i > 0) keywords.add(text.substring(0, i));
    }

    //taking second onward words
    final List<String> split = text.split(' ');
    if (split.length > 1) {
      split.removeAt(0);
      keywords.addAll(split);
    }
    log.i(keywords);
    return keywords;
  }
}
