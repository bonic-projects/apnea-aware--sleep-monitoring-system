import 'package:apnea_aware/app/app.locator.dart';
import 'package:apnea_aware/app/app.router.dart';
import 'package:apnea_aware/services/user_service.dart';
import 'package:stacked/stacked.dart';

import 'package:stacked_services/stacked_services.dart';

class AlertViewModel extends BaseViewModel {
  final _naviigatorService = locator<NavigationService>();
  final _userService = locator<UserService>();
  //final _movementDatabaseService = locator<MovementDatabaseService>();

  void popPop() {
    _naviigatorService.popRepeated(1);
  }

  void popback() {
    _userService.deleteVideoId();
    if(_userService.user!.userRole == "Patient"){
      _naviigatorService.pushNamedAndRemoveUntil(Routes.patientView);
    }else{
      _naviigatorService.pushNamedAndRemoveUntil(Routes.doctorView);
    }

    
  }
}
