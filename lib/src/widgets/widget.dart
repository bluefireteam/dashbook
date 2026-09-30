import 'dart:async';

import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/platform_utils/platform_utils.dart';
import 'package:dashbook/src/preferences.dart';
import 'package:dashbook/src/story_util.dart';
import 'package:dashbook/src/widgets/dashbook_page.dart';
import 'package:dashbook/src/widgets/select_device/device_settings.dart';
import 'package:dashbook/src/widgets/theme_icons.dart';
import 'package:material_ui/material_ui.dart';

typedef OnChapterChange = void Function(Chapter);

class _DashbookDualTheme {
  const _DashbookDualTheme({
    required this.light,
    required this.dark,
    this.initWithLight = true,
  });

  final ThemeData light;
  final ThemeData dark;
  final bool initWithLight;
}

class _DashbookMultiTheme {
  const _DashbookMultiTheme({required this.themes, this.initialTheme});

  final Map<String, ThemeData> themes;
  final String? initialTheme;

  String get initialThemeName {
    final initialTheme = this.initialTheme;
    return initialTheme != null && themes.containsKey(initialTheme)
        ? initialTheme
        : themes.keys.first;
  }
}

class Dashbook extends StatefulWidget {
  Dashbook({
    super.key,
    this.theme,
    this.title = '',
    this.usePreviewSafeArea = false,
    this.autoPinStoriesOnLargeScreen = false,
    this.navigatorKey,
    this.onChapterChange,
    this.localizationsDelegates,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
  }) : _dualTheme = null,
       _multiTheme = null;

  Dashbook.dualTheme({
    required ThemeData light,
    required ThemeData dark,
    super.key,
    bool initWithLight = true,
    this.title = '',
    this.usePreviewSafeArea = false,
    this.autoPinStoriesOnLargeScreen = false,
    this.navigatorKey,
    this.onChapterChange,
    this.localizationsDelegates,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
  }) : _dualTheme = _DashbookDualTheme(
         dark: dark,
         light: light,
         initWithLight: initWithLight,
       ),
       theme = null,
       _multiTheme = null;

  Dashbook.multiTheme({
    required Map<String, ThemeData> themes,
    super.key,
    String? initialTheme,
    this.title = '',
    this.usePreviewSafeArea = false,
    this.autoPinStoriesOnLargeScreen = false,
    this.navigatorKey,
    this.onChapterChange,
    this.localizationsDelegates,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
  }) : assert(themes.isNotEmpty, 'At least one theme has to be provided'),
       _multiTheme = _DashbookMultiTheme(
         themes: themes,
         initialTheme: initialTheme,
       ),
       theme = null,
       _dualTheme = null;

  final List<Story> stories = [];
  final ThemeData? theme;
  final _DashbookDualTheme? _dualTheme;
  final _DashbookMultiTheme? _multiTheme;
  final String title;
  final bool usePreviewSafeArea;
  final bool autoPinStoriesOnLargeScreen;
  final GlobalKey<NavigatorState>? navigatorKey;
  final List<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final List<Locale> supportedLocales;

  /// Called whenever a new chapter is selected.
  final OnChapterChange? onChapterChange;

  Story storiesOf(String name) {
    final story = Story(name);
    stories.add(story);

    return story;
  }

  @override
  State<Dashbook> createState() => _DashbookState();
}

class _DashbookState extends State<Dashbook> {
  final _preferences = DashbookPreferences();
  Chapter? _initialChapter;
  bool _loading = true;
  late bool _isDarkTheme = !(widget._dualTheme?.initWithLight ?? true);
  late String? _themeName = widget._multiTheme?.initialThemeName;

  ThemeData? get _theme => switch (widget) {
    Dashbook(_dualTheme: final dualTheme?) =>
      _isDarkTheme ? dualTheme.dark : dualTheme.light,
    Dashbook(_multiTheme: final multiTheme?) => multiTheme.themes[_themeName],
    _ => widget.theme,
  };

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    await _preferences.load();
    if (!mounted) {
      return;
    }

    final bookmark = _preferences.bookmarkedChapter;
    final initialChapter =
        getInitialChapter(widget.stories) ??
        (bookmark == null ? null : findChapter(bookmark, widget.stories)) ??
        widget.stories.expand((story) => story.chapters).firstOrNull;

    if (initialChapter != null) {
      widget.onChapterChange?.call(initialChapter);
    }

    setState(() {
      _initialChapter = initialChapter;
      _loading = false;
    });
  }

  Route<void> _createRoute() {
    return MaterialPageRoute<void>(
      builder: (_) => DashbookPage(
        stories: widget.stories,
        preferences: _preferences,
        initialChapter: _initialChapter,
        usePreviewSafeArea: widget.usePreviewSafeArea,
        autoPinStoriesOnLargeScreen: widget.autoPinStoriesOnLargeScreen,
        onChapterChange: widget.onChapterChange,
        themeIcon: switch (widget) {
          Dashbook(_dualTheme: _?) => DualThemeIcon(
            isDarkTheme: _isDarkTheme,
            onChanged: (isDarkTheme) {
              setState(() => _isDarkTheme = isDarkTheme);
            },
          ),
          Dashbook(_multiTheme: final multiTheme?) => MultiThemeIcon(
            themeNames: multiTheme.themes.keys.toList(),
            currentTheme: _themeName,
            onChanged: (themeName) {
              setState(() => _themeName = themeName);
            },
          ),
          _ => null,
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox.shrink();
    }

    return DeviceSettings(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: widget.navigatorKey,
        title: widget.title,
        theme: _theme,
        localizationsDelegates: widget.localizationsDelegates,
        supportedLocales: widget.supportedLocales,
        // Needed until device_frame, flutter_colorpicker and
        // flutter_markdown_plus have migrated from package:flutter/material.dart to material_ui.
        // ignore: deprecated_member_use
        builder: (_, child) => MaterialUiCompatibilityBridge(child: child!),
        onGenerateInitialRoutes: (_) => [_createRoute()],
        onGenerateRoute: (_) => _createRoute(),
      ),
    );
  }
}
