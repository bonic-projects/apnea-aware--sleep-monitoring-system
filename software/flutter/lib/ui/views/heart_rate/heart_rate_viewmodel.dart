import 'package:apnea_aware/app/app.locator.dart';
import 'package:apnea_aware/app/app.logger.dart';
import 'package:apnea_aware/models/devices.dart';
import 'package:apnea_aware/services/database_service.dart';

import 'package:stacked/stacked.dart';

class HeartRateViewModel extends ReactiveViewModel {
  final log = getLogger('HomeViewModel');

  final _databaseService = locator<DatabaseService>();
  DeviceReading? get node => _databaseService.node;

  @override
  List<ListenableServiceMixin> get listenableServices => [_databaseService];
}
