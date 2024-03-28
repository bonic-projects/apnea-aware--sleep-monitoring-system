import 'package:apnea_aware/app/app.locator.dart';
import 'package:apnea_aware/app/app.logger.dart';
import 'package:apnea_aware/app/app.router.dart';
import 'package:apnea_aware/models/appuser.dart';
import 'package:apnea_aware/services/user_service.dart';
import 'package:apnea_aware/services/videosdk_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PatientViewModel extends BaseViewModel {
  final log = getLogger('patientViewModel');

  final _navigationService = locator<NavigationService>();
  final _userService = locator<UserService>();

  void logoutUser() {
    _userService.deleteVideoId();
    _userService.logout();
    _navigationService.pushNamedAndRemoveUntil(Routes.loginRegisterView);
  }

  final _videosdkService = locator<VideosdkService>();
  void createVideoCall() async {
    setBusy(true);
    String? m = await _videosdkService.createMeeting();
    if (m != null) {
      log.i("MMMM");
      log.v(m);
      _meetingId = m;
      log.i(meetingId);

      await Future.delayed(const Duration(seconds: 1));
      setBusy(false);
      await _userService.updateUser(AppUser(
        videoId: m,
        isVideoOn: true,
        id: '',
        fullName: '',
        photoUrl: '',
        email: '',
        userRole: '',
        regTime: DateTime.now(),
      ));
      _navigationService.navigateToVideocallView(meetingid: meetingId);
    }
  }

  String _meetingId = "";
  String get meetingId => _meetingId;
}
