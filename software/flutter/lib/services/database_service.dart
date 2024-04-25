import 'package:firebase_database/firebase_database.dart';
import 'package:stacked/stacked.dart';

import 'package:apnea_aware/models/devices.dart';

import '../app/app.logger.dart';

const dbCode = "plX7kE7mAQQ5YgcKRsjp5b6t8Ac2";

class DatabaseService with ListenableServiceMixin {
  final log = getLogger('RealTimeDB_Service');

  final FirebaseDatabase _db = FirebaseDatabase.instance;

  DeviceReading? _node;
  DeviceReading? get node => _node;

  Future getDeviceData() async {
    DatabaseReference dataRef = _db.ref('/devices/$dbCode/ml');
    final value = await dataRef.once();
    if (value.snapshot.exists) {
      log.i("New data");
      return value.snapshot.value;
    }
    return null;
  }

  void setDeviceData(DeviceData data) {
    DatabaseReference dataRef = _db.ref('/devices/$dbCode/reading');
    dataRef.update(data.toJson());
  }

  void setupNodeListening() {
    DatabaseReference starCountRef = _db.ref('/devices/$dbCode/reading');
    log.i("R ${starCountRef.key}");
    log.i("CHECKING..");
    try {
      log.i('try called');
      starCountRef.onValue.listen((DatabaseEvent event) {
        // log.i("Reading..");
        if (event.snapshot.exists) {
          // log.i("DATA RECIEVED..");
          _node = DeviceReading.fromMap(event.snapshot.value as Map);
          // log.v(_node); //data['time']
          notifyListeners();
        }
      });
    } catch (e) {
      log.e("Error: $e");
    }
  }
}
