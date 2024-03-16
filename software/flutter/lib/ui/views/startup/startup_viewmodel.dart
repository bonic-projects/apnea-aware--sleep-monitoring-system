import 'dart:math';

import 'package:apnea_aware/app/app.logger.dart';
import 'package:apnea_aware/services/database_service.dart';
import 'package:apnea_aware/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:apnea_aware/app/app.locator.dart';
import 'package:apnea_aware/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _userService = locator<UserService>();
  final _databaseService = locator<DatabaseService>();
  final log = getLogger('startupView');

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    _databaseService.setupNodeListening();
    log.i('startup called');
    if (_userService.hasLoggedInUser) {
      await _userService.fetchUser();
      _navigationService.replaceWithHomeView();
    } else {
      await Future.delayed(const Duration(seconds: 1));
      _navigationService.replaceWithLoginRegisterView();
    }
    // _regulaService.initPlatformState();
  }
}
