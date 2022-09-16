import 'package:dashbook/src/preferences.dart';
import 'package:dashbook/src/story.dart';
import 'package:dashbook/src/widgets/widget.dart';
import 'package:flutter/material.dart';

class DashbookConfig {
  DashbookConfig({
    required this.title,
    required this.usePreviewSafeArea,
    required this.autoPinStoriesOnLargeScreen,
    required this.stories,
    required this.preferences,
  });

  final String title;
  final bool usePreviewSafeArea;
  final bool autoPinStoriesOnLargeScreen;
  final List<Story> stories;
  final DashbookPreferences preferences;
}

class ThemeSettings {
  ThemeSettings({
    ThemeData? theme,
    this.dualTheme,
    this.multiTheme,
  }) : currentTheme = theme ??
            dualTheme?.light ??
            multiTheme?.themes.values.first ??
            ThemeData.light();

  ThemeData currentTheme;
  DashbookDualTheme? dualTheme;
  DashbookMultiTheme? multiTheme;
}
