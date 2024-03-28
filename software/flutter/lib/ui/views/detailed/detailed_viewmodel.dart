import 'dart:async';

import 'package:apnea_aware/app/app.locator.dart';
import 'package:apnea_aware/app/app.logger.dart';
import 'package:apnea_aware/services/database_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stacked/stacked.dart';

import '../../../models/devices.dart';

class DetailedViewModel extends ReactiveViewModel {
  final _databaseService = locator<DatabaseService>();

  final log = getLogger('DetailedViewModel');

  DeviceReading? get node => _databaseService.node;

  late Timer _timer;
  int heartRateCount = 0;
  int spo2Count = 0;

  List<FlSpot> heartRateSpots = [];
  List<FlSpot> spo2Spots = [];

  void onModelReady() {
    // Start the timer when the ViewModel is initialized
    _startTimer();
  }

  // Method to start the timer and update spots list every second
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateHeartRateSpots();
      _updateSpo2Spots();
    });
  }

  // Method to update spots list based on device data
  void _updateHeartRateSpots() {
    if (node != null) {
      heartRateCount++;
      FlSpot s = FlSpot(heartRateCount.toDouble(), node!.heartrate);
      heartRateSpots.add(s);
      if (heartRateCount > 50) {
        heartRateSpots.removeAt(0);
      }
      // Notify listeners to update the UI
      notifyListeners();
    } else {
      _timer.cancel();
    }
  }

  void _updateSpo2Spots() {
    if (node != null) {
      spo2Count++;
      FlSpot s = FlSpot(spo2Count.toDouble(), node!.spo2);
      spo2Spots.add(s);
      if (spo2Count > 50) {
        spo2Spots.removeAt(0);
      }
      // Notify listeners to update the UI
      notifyListeners();
    } else {
      _timer.cancel();
    }
  }
}
