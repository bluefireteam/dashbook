import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/dashbook_config.dart';
import 'package:dashbook/src/platform_utils/platform_utils.dart';
import 'package:dashbook/src/preferences.dart';
import 'package:dashbook/src/story_util.dart';
import 'package:dashbook/src/widgets/dashbook_content.dart';
import 'package:flutter/material.dart';

typedef OnChapterChange = void Function(Chapter);

class DashbookDualTheme {
  final ThemeData light;
  final ThemeData dark;
  final bool initWithLight;

  DashbookDualTheme({
    required this.light,
    required this.dark,
    this.initWithLight = true,
  });
}

class DashbookMultiTheme {
  final Map<String, ThemeData> themes;
  final String? initialTheme;

  DashbookMultiTheme({
    required this.themes,
    this.initialTheme,
  });
}

enum CurrentView {
  stories,
  properties,
  actions,
}
