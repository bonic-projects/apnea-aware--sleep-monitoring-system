import 'dart:async';

import 'package:apnea_aware/app/app.locator.dart';
import 'package:apnea_aware/app/app.logger.dart';
import 'package:apnea_aware/models/devices.dart';
import 'package:apnea_aware/services/database_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stacked/stacked.dart';

class MovementViewModel extends ReactiveViewModel {
  final log = getLogger('MovementViewModel');

  final _databaseService = locator<DatabaseService>();
  DeviceReading? get node => _databaseService.node;

  late Timer _timer;
  int gyroxCount = 0;
  int gyroyCount = 0;
  int gyrozCount = 0;
  int accelerationxCount = 0;
  int accelerationyCount = 0;
  int accelerationzCount = 0;

  List<FlSpot> gyroXSpots = [];
  List<FlSpot> gyroYSpots = [];
  List<FlSpot> gyroZSpots = [];
  List<FlSpot> accelerationXSpots = [];
  List<FlSpot> accelerationYSpots = [];
  List<FlSpot> accelerationZSpots = [];

  @override
  List<ListenableServiceMixin> get listenableServices => [_databaseService];

  void onModelReady() {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updategyroXSpots();
      _updategyroySpots();
      _updategyroZSpots();
      _updateaccelerationXSpots();
      _updateaccelerationYSpots();
      _updateaccelerationZSpots();
    });
  }

  void _updategyroXSpots() {
    if (node != null) {
      gyroxCount++;
      gyroXSpots.add(FlSpot(gyroxCount.toDouble(), node!.gyroX));
      if (gyroxCount > 15) {
        gyroXSpots.removeAt(0);
        notifyListeners();
        _timer.cancel();
      }
    }
  }

  void _updategyroySpots() {
    if (node != null) {
      gyroyCount++;
      gyroYSpots.add(FlSpot(gyroyCount.toDouble(), node!.gyroY));
      if (gyroyCount > 15) {
        gyroYSpots.removeAt(0);
        notifyListeners();
        _timer.cancel();
      }
    }
  }

  void _updategyroZSpots() {
    if (node != null) {
      gyrozCount++;
      gyroZSpots.add(FlSpot(gyrozCount.toDouble(), node!.gyroZ));
      if (gyrozCount > 15) {
        gyroZSpots.removeAt(0);
        notifyListeners();
        _timer.cancel();
      }
    }
  }

  void _updateaccelerationXSpots() {
    if (node != null) {
      accelerationxCount++;
      accelerationXSpots
          .add(FlSpot(accelerationxCount.toDouble(), node!.acclX));
      if (accelerationxCount > 15) {
        accelerationXSpots.removeAt(0);
        notifyListeners();
        _timer.cancel();
      }
    }
  }

  void _updateaccelerationYSpots() {
    if (node != null) {
      accelerationyCount++;
      accelerationYSpots
          .add(FlSpot(accelerationyCount.toDouble(), node!.acclY));
      if (accelerationyCount > 15) {
        accelerationYSpots.removeAt(0);
        notifyListeners();
        _timer.cancel();
      }
    }
  }

  void _updateaccelerationZSpots() {
    if (node != null) {
      accelerationzCount++;
      accelerationZSpots
          .add(FlSpot(accelerationzCount.toDouble(), node!.acclZ));
      if (accelerationzCount > 15) {
        accelerationZSpots.removeAt(0);
        notifyListeners();
        _timer.cancel();
      }
    }
  }
}
