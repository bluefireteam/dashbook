import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterSetScreenSize on WidgetTester {
  void setScreenSize(Size size) {
    view.physicalSize = size;
    addTearDown(view.resetPhysicalSize);
  }
}
