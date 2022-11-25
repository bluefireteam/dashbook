import 'package:dashbook/src/dashbook_config.dart';
import 'package:dashbook/src/platform_utils/platform_utils.dart';
import 'package:flutter/widgets.dart';

class DashbookBrand {
  final String name;
  final String path;
  final IconBuilder iconBuilder;
  final ThemeSettings themeSettings;

  DashbookBrand({
    required this.name,
    String? path,
    required this.iconBuilder,
    required this.themeSettings,
  }) : path = path ?? PlatformUtils.normalizePathName(name);
}

typedef IconBuilder = Widget Function(
  BuildContext context,
  ScreenSize size,
);

enum ScreenSize {
  small,
  large,
}
