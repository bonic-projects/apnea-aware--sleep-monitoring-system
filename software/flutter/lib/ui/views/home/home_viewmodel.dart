import 'package:apnea_aware/app/app.locator.dart';
import 'package:apnea_aware/app/app.logger.dart';
import 'package:apnea_aware/app/app.router.dart';

import 'package:apnea_aware/services/database_service.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final log = getLogger('HomeViewModel');
  final _navigationService = locator<NavigationService>();
  final _databaseService = locator<DatabaseService>();

  List<ListenableServiceMixin> get listenableServices => [_databaseService];

  void heartRateView() {
    _navigationService.navigateTo(Routes.heartRateView);
  }

  void detailed() {
    _navigationService.navigateTo(Routes.detailedView);
  }

  void accerelatorView() {
    _navigationService.navigateTo(Routes.accerelatorView);
  }
}
