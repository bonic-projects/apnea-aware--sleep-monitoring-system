import 'package:apnea_aware/app/app.locator.dart';
import 'package:apnea_aware/app/app.logger.dart';
import 'package:apnea_aware/app/app.router.dart';

import 'package:apnea_aware/services/database_service.dart';
import 'package:apnea_aware/services/user_service.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final log = getLogger('HomeViewModel');
  final _navigationService = locator<NavigationService>();
  final _databaseService = locator<DatabaseService>();

  final _userService = locator<UserService>();

  List<ListenableServiceMixin> get listenableServices => [_databaseService];

  void logout() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _userService.logout();
    _navigationService.replaceWithLoginRegisterView();
  }

  void heartRateView() {
    _navigationService.navigateTo(Routes.heartRateView);
  }

  void detailed() {
    _navigationService.navigateTo(Routes.detailedView);
  }

  void accerelatorView() {
    _navigationService.navigateTo(Routes.movementView);
  }

  void patientView() {
    _navigationService.navigateTo(Routes.patientView);
  }

  // void navigateBasedOnRole() async {
  //   AppUser? user = await _userService.fetchUser();
  //   if (user != null) {
  //     final userRole = user.userRole;
  //     if (userRole == "doctor") {
  //       _navigationService.navigateTo(Routes.doctorView);
  //     } else {
  //       _navigationService.navigateTo(Routes.patientView);
  //     }
  //   }
  // }
}
