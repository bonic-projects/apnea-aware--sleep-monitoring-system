/// Device Sensor Reading model
/// Device Sensor Reading model
class DeviceReading {
  double heartrate;
  double spo2;
  double acceleration;

  DeviceReading({
    required this.heartrate,
    required this.spo2,
    required this.acceleration,
  });

  factory DeviceReading.fromMap(Map data) {
    return DeviceReading(
      heartrate: data['heartrate'],
      spo2: data['spo2'],
      acceleration: data['acceleration'],
    );
  }
}

// / Device control model
class DeviceData {
  bool r1;
  bool r2;
  bool r3;
  bool r4;
  String phone;

  DeviceData({
    required this.r1,
    required this.r2,
    required this.r3,
    required this.r4,
    required this.phone,
  });

  factory DeviceData.fromMap(Map data) {
    return DeviceData(
      r1: data['r1'] ?? false,
      r2: data['r2'] ?? false,
      r3: data['r3'] ?? false,
      r4: data['r4'] ?? false,
      phone: data['phone'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'r1': r1,
        'r2': r2,
        'r3': r3,
        'r4': r4,
      };
}
