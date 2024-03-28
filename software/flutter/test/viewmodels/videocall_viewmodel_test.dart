import 'package:flutter_test/flutter_test.dart';
import 'package:apnea_aware/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('VideocallViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
