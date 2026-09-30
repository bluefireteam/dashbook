import 'package:material_ui/material_ui.dart';

extension DeviceSizeExtension on BuildContext {
  bool get isPhoneSize => MediaQuery.sizeOf(this).width <= _Breakpoint.small;
  bool get isNotPhoneSize => !isPhoneSize;
  bool get isWideScreen => MediaQuery.sizeOf(this).width > _Breakpoint.large;
}

/// These breakpoints are matched to those defined by the [material docs](https://material.io/design/layout/understanding-layout.html)
class _Breakpoint {
  static const small = 600;
  static const large = 1440;
}
