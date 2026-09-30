import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterSetScreenSize on WidgetTester {
  void setScreenSize(Size size) {
    view
      ..devicePixelRatio = 1
      ..physicalSize = size;
    addTearDown(view.reset);
  }
}
