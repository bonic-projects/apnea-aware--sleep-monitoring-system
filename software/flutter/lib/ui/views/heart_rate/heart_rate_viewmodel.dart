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
  String _serverIP = '192.168.29.207'; // Variable to store server IP
  String get serverIP => _serverIP; // Variable to store server IP

  List<Map<String, dynamic>>? _predictions;
  List<Map<String, dynamic>>? get predictions=> _predictions;

  // Method to set server IP
  void setServerIP(String value) {
    _serverIP = value;
    notifyListeners();
  }

  String? _predictedClass;
  String? get predictedClass => _predictedClass;

  Future<List<dynamic>?> getPredictions() async {
    log.i("Preicting..");
    setBusy(true);

    try {
      final response = await http.post(
        Uri.parse('http://$_serverIP:5000/predict'), // Use server IP
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'beatAvg': node!.heartrate,
          'sp02Avg': node!.spo2,
          'dB': node!.dB,
        }),
      );

      log.i("Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        log.i("Successfull request");
        Map<String, dynamic> data = jsonDecode(response.body);
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
        if(_predictions!=null) {
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

          if(predictedClass == "bad") {
            // _notificationService.send();
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

  bool get switchValue => _switchValue;

  void switchValueChanged(bool newValue) {
    _switchValue = newValue;
    if (_switchValue) {
      _startTimer();
    } else {
      _cancelTimer();
    }
    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      getPredictions();
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
