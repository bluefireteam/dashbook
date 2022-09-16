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

class Dashbook extends StatefulWidget {
  final List<Story> stories = [];
  final ThemeData? theme;
  final DashbookDualTheme? _dualTheme;
  final DashbookMultiTheme? _multiTheme;
  final String title;
  final bool usePreviewSafeArea;
  final bool autoPinStoriesOnLargeScreen;
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Called whenever a new chapter is selected.
  final OnChapterChange? onChapterChange;

  Dashbook({
    Key? key,
    this.theme,
    this.title = '',
    this.usePreviewSafeArea = false,
    this.autoPinStoriesOnLargeScreen = false,
    this.navigatorKey,
    this.onChapterChange,
  })  : _dualTheme = null,
        _multiTheme = null,
        super(key: key);

  Dashbook.dualTheme({
    Key? key,
    required ThemeData light,
    required ThemeData dark,
    bool initWithLight = true,
    this.title = '',
    this.usePreviewSafeArea = false,
    this.autoPinStoriesOnLargeScreen = false,
    this.navigatorKey,
    this.onChapterChange,
  })  : _dualTheme = DashbookDualTheme(
          dark: dark,
          light: light,
          initWithLight: initWithLight,
        ),
        theme = null,
        _multiTheme = null,
        super(key: key);

  Dashbook.multiTheme({
    Key? key,
    required Map<String, ThemeData> themes,
    String? initialTheme,
    this.title = '',
    this.usePreviewSafeArea = false,
    this.autoPinStoriesOnLargeScreen = false,
    this.navigatorKey,
    this.onChapterChange,
  })  : _multiTheme =
            DashbookMultiTheme(themes: themes, initialTheme: initialTheme),
        theme = null,
        _dualTheme = null,
        super(key: key);

  Story storiesOf(String name) {
    final story = Story(name);
    stories.add(story);

    return story;
  }

  @override
  State<StatefulWidget> createState() {
    return _DashbookState();
  }
}

enum CurrentView {
  stories,
  properties,
  actions,
}

class _DashbookState extends State<Dashbook> {
  Chapter? _currentChapter;
  CurrentView? _currentView;
  ThemeData? _currentTheme;
  late DashbookPreferences _preferences;
  bool _loading = true;
  late DashbookConfig dashbookConfig;

  @override
  void initState() {
    super.initState();

    if (widget.theme != null) {
      _currentTheme = widget.theme;
    } else if (widget._dualTheme != null) {
      final _dualTheme = widget._dualTheme;
      _currentTheme =
          _dualTheme!.initWithLight ? _dualTheme.light : _dualTheme.dark;
    } else if (widget._multiTheme != null) {
      final _multiTheme = widget._multiTheme;
      _currentTheme = _multiTheme!.themes[_multiTheme.initialTheme] ??
          _multiTheme.themes.values.first;
    }
    _finishLoading();
  }

  Future<void> _finishLoading() async {
    final preferences = DashbookPreferences();
    await preferences.load();

    var initialChapter = PlatformUtils.getInitialChapter(widget.stories);

    if (initialChapter == null) {
      if (preferences.bookmarkedChapter != null) {
        initialChapter =
            findChapter(preferences.bookmarkedChapter!, widget.stories);
      } else if (widget.stories.isNotEmpty) {
        final story = widget.stories.first;

        if (story.chapters.isNotEmpty) {
          initialChapter = story.chapters.first;
        }
      }
    }

    if (initialChapter != null) {
      widget.onChapterChange?.call(initialChapter);
    }

    setState(() {
      _currentChapter = initialChapter;
      _preferences = preferences;

      dashbookConfig = DashbookConfig(
        title: widget.title,
        usePreviewSafeArea: widget.usePreviewSafeArea,
        autoPinStoriesOnLargeScreen: widget.autoPinStoriesOnLargeScreen,
        stories: widget.stories,
        preferences: _preferences,
      );
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: widget.navigatorKey,
      title: widget.title,
      theme: _currentTheme,
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          builder: (context) {
            return Scaffold(
              body: DashbookContent(
                config: dashbookConfig,
                currentChapter: _currentChapter,
                currentView: _currentView,
                onChapterChange: (chapter) => setState(
                  () => _currentChapter = chapter,
                ),
                onViewChange: (view) => setState(
                  () => _currentView = view,
                ),
                themeSettings: ThemeSettings(
                  theme: _currentTheme,
                  dualTheme: widget._dualTheme,
                  multiTheme: widget._multiTheme,
                ),
                onThemeChange: (theme) => setState(() => _currentTheme = theme),
              ),
            );
          },
        );
      },
    );
  }
}
