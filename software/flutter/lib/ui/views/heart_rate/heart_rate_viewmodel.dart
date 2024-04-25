import 'dart:async';

import 'package:apnea_aware/app/app.locator.dart';
import 'package:apnea_aware/app/app.logger.dart';
import 'package:apnea_aware/models/devices.dart';
import 'package:apnea_aware/services/database_service.dart';

import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HeartRateViewModel extends ReactiveViewModel {
  final log = getLogger('HomeViewModel');

  final _databaseService = locator<DatabaseService>();
  DeviceReading? get node => _databaseService.node;

  @override
  List<ListenableServiceMixin> get listenableServices => [_databaseService];

  List<Map<String, dynamic>>? _predictions;
  List<Map<String, dynamic>>? get predictions => _predictions;

  // Method to set server IP


  String? _predictedClass;
  String? get predictedClass => _predictedClass;

  Future<List<dynamic>?> getPredictions() async {
    log.i("Preicting..");
    setBusy(true);

    try {
      final response = await _databaseService.getDeviceData();

      if (response!= null) {
        log.i("Successfull request");
        Map<String, dynamic> data = response;
        final predictions = data['predictions'];
        // Check if predictions is a List<Map<String, dynamic>>
        if (predictions is List) {
          _predictions = predictions.cast<Map<String, dynamic>>();
          log.i("Parsed predictions");
        } else {
          log.e("Predictions is not a List<Map<String, dynamic>>");
        }

        log.i("Data: ");
        log.i(_predictions);
        if (_predictions != null) {
          // getClassWithHighestProbability(predictions);

          ///===========================
          // Initialize variables to store the highest probability and corresponding class
          double maxProbability = 0.0;
          String predictedClass = '';

          // Iterate through the prediction data
          for (var prediction in _predictions!) {
            // Extract probability and class from the current prediction
            double probability = prediction['probability'];
            String status = prediction['status'];

            // Update maxProbability and predictedClass if the current probability is higher
            if (probability > maxProbability) {
              maxProbability = probability;
              predictedClass = status;
            }
          }

          _predictedClass = predictedClass;
          log.i("_predictedClass: $_predictedClass");

          ///==============================
        }

        setBusy(false);
        return predictions;
      } else {
        setBusy(false);
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      setBusy(false);
      rethrow;
    }
  }

  bool _switchValue = false;
  Timer? _timer;

  bool get isAuto => _switchValue;

  void switchValueChanged(bool newValue) {
    _switchValue = newValue;
    if (_switchValue) {
      _startTimer();
    } else {
      _cancelTimer();
    }
    notifyListeners();
  }

  int _ahi = 0;
  int get ahi => _ahi;
  int _eventNo = 0;
  int get eventNo => _eventNo;
  int _sleepTimes = 0;
  int _sleepTimeInMinute = 0;
  int get sleepTimeInMinute => _sleepTimeInMinute;
  void calculateAhi() {
    _sleepTimes++;
    _sleepTimeInMinute = (_sleepTimes * 5) ~/ 60;
    if (predictedClass == "apnea") {
      _eventNo++;
    } else if (predictedClass == "hypopnea") {
      _eventNo++;
    }
    // predictions!.map((prediction) {
    //   if (prediction['status'] == "apnea") {
    //     _eventNo++;
    //   } else if (prediction['status'] == "hypopnea") {
    //     _eventNo++;
    //   }
    // });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) async {
      List<dynamic>? predictions = await getPredictions();
      if (predictions != null) {
        calculateAhi();
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
