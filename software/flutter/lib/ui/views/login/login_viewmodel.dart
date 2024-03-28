import 'package:apnea_aware/app/app.logger.dart';
import 'package:apnea_aware/app/app.router.dart';
import 'package:apnea_aware/services/user_service.dart';
import 'package:apnea_aware/ui/views/login/login_view.form.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';

class LoginViewModel extends FormViewModel {
  final log = getLogger('LoginViewModel');

  final FirebaseAuthenticationService _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final _navigationService = locator<NavigationService>();
  // final _userService = locator<UserService>();
  final _snackBarService = locator<SnackbarService>();
  final _userService = locator<UserService>();
  void onModelReady() {}

  void authenticateUser() async {
    if (isFormValid && emailValue != null && passwordValue != null) {
      setBusy(true);
      log.i("email and pass valid");
      log.i(emailValue!);
      log.i(passwordValue!);
      FirebaseAuthenticationResult result =
          await _firebaseAuthenticationService.loginWithEmail(
        email: emailValue!,
        password: passwordValue!,
      );
      if (result.user != null) {
        await _userService.fetchUser();
        if (_userService.user!.userRole == "Patient") {
          _navigationService.pushNamedAndRemoveUntil(Routes.homeView);
        } else {
          _navigationService.pushNamedAndRemoveUntil(Routes.doctorView);
        }
        // Await fetchUser() if needed
      } else {
        log.e("Error: ${result.errorMessage}");

        _snackBarService.showSnackbar(
            message:
                "Error: ${result.errorMessage ?? "Enter valid credentials"}");
      }
    }
    setBusy(false);
  }
}
