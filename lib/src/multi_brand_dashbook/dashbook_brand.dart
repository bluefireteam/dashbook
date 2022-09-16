import 'package:dashbook/src/dashbook_config.dart';
import 'package:flutter/widgets.dart';

class DashbookBrand {
  final String name;
  final String path;
  final Widget icon;
  final ThemeSettings themeSettings;

  const DashbookBrand({
    required this.name,
    String? path,
    required this.icon,
    required this.themeSettings,
  }) : path = path ?? name;
}
