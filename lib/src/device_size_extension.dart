import 'package:flutter/material.dart';

extension DeviceSizeExtension on BuildContext {
  /// Is extra small is the group of device
  SizeCategory get sizeCategory {
    final width = MediaQuery.of(this).size.width;
    if (width > _Breakpoint.large) return SizeCategory.desktop;
    if (width > _Breakpoint.medium) return SizeCategory.laptop;
    if (width > _Breakpoint.small) return SizeCategory.tablet;
    return SizeCategory.phone;
  }

  bool get isNotPhoneSize => !isPhoneSize;
  bool get isPhoneSize => sizeCategory == SizeCategory.phone;
  bool get isTabletSize => sizeCategory == SizeCategory.tablet;
  bool get isLaptopSize => sizeCategory == SizeCategory.laptop;
  bool get isDesktopSize => sizeCategory == SizeCategory.desktop;

  bool get isWideScreen {
    final width = MediaQuery.of(this).size.width;
    return width > _Breakpoint.large;
  }
}

enum SizeCategory {
  phone,
  tablet,
  laptop,
  desktop,
}

/// These breakpoints are matched to those defined by the [material docs](https://material.io/design/layout/understanding-layout.html)
/// The number represents the point it starts, so a device between 600 and
/// 1240px wide is considered small.
class _Breakpoint {
  static const small = 600;
  static const medium = 1240;
  static const large = 1440;
}
