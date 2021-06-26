import 'package:dashbook/src/widgets/keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../platform_utils/platform_utils.dart';
import './preview_container.dart';
import './properties_container.dart';
import './stories_list.dart';
import './icon.dart';
import './helpers.dart';
import '../story.dart';
import '../story_util.dart';
import './intructions_dialog.dart';
import '../preferences.dart';

class _DashbookDualTheme {
  final ThemeData light;
  final ThemeData dark;
  final bool initWithLight;

  _DashbookDualTheme({
    required this.light,
    required this.dark,
    this.initWithLight = true,
  });
}

class _DashbookMultiTheme {
  final Map<String, ThemeData> themes;
  final String? initialTheme;

  _DashbookMultiTheme({
    required this.themes,
    this.initialTheme,
  });
}

class Dashbook extends StatefulWidget {
  final List<Story> stories = [];
  final ThemeData? theme;
  final _DashbookDualTheme? dualTheme;
  final _DashbookMultiTheme? multiTheme;
  final String title;
  final bool usePreviewSafeArea;
  final GlobalKey<NavigatorState>? navigatorKey;

  Dashbook({
    this.theme,
    this.title = '',
    this.usePreviewSafeArea = false,
    this.navigatorKey,
  })  : dualTheme = null,
        multiTheme = null;

  Dashbook.dualTheme({
    required ThemeData light,
    required ThemeData dark,
    bool initWithLight = true,
    this.title = '',
    this.usePreviewSafeArea = false,
    this.navigatorKey,
  })  : dualTheme = _DashbookDualTheme(
            dark: dark, light: light, initWithLight: initWithLight),
        theme = null,
        multiTheme = null;

  Dashbook.multiTheme({
    required Map<String, ThemeData> themes,
    String? initialTheme,
    this.title = '',
    this.usePreviewSafeArea = false,
    this.navigatorKey,
  })  : multiTheme =
            _DashbookMultiTheme(themes: themes, initialTheme: initialTheme),
        theme = null,
        dualTheme = null;

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
  STORIES,
  PROPERTIES,
}

class _DashbookState extends State<Dashbook> {
  Chapter? _currentChapter;
  CurrentView? _currentView;
  ThemeData? _currentTheme;
  late DashbookPreferences _preferences;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    if (widget.theme != null) {
      _currentTheme = widget.theme!;
    } else if (widget.dualTheme != null) {
      final dualTheme = widget.dualTheme;
      _currentTheme =
          dualTheme!.initWithLight ? dualTheme.light : dualTheme.dark;
    } else if (widget.multiTheme != null) {
      final multiTheme = widget.multiTheme;
      _currentTheme = multiTheme!.themes[multiTheme.initialTheme] ??
          multiTheme.themes.values.first;
    }
    _finishLoading();
  }

  void _finishLoading() async {
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

    setState(() {
      _currentChapter = initialChapter;
      _preferences = preferences;
      _loading = false;
    });
  }

  bool _hasProperties() => _currentChapter?.ctx.properties.isNotEmpty ?? false;

  Future<void> _launchURL(String url) async {
    if (await url_launcher.canLaunch(url)) {
      await url_launcher.launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
        return MaterialPageRoute(builder: (context) {
          final chapterWidget = _currentChapter?.widget();
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  if (_currentChapter != null)
                    PreviewContainer(
                      key: Key(_currentChapter!.id),
                      child: chapterWidget!,
                      usePreviewSafeArea: widget.usePreviewSafeArea,
                      isPropertiesOpen: _currentView == CurrentView.PROPERTIES,
                    ),
                  Positioned(
                    right: 10,
                    top: 0,
                    bottom: 0,
                    child: _DashbookRightIconList(
                      children: [
                        if (_hasProperties())
                          DashbookIcon(
                            key: kPropertiesIcon,
                            tooltip: 'Properties panel',
                            icon: Icons.mode_edit,
                            onClick: () => setState(
                                () => _currentView = CurrentView.PROPERTIES),
                          ),
                        if (_currentChapter?.info != null)
                          DashbookIcon(
                              tooltip: 'Instructions',
                              icon: Icons.info,
                              onClick: () {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return InstructionsDialog(
                                        instructions: _currentChapter!.info!,
                                      );
                                    });
                              }),
                        if (_currentChapter?.codeLink != null)
                          DashbookIcon(
                            tooltip: 'See code',
                            icon: Icons.code,
                            onClick: () =>
                                _launchURL(_currentChapter!.codeLink!),
                          ),
                        if (widget.dualTheme != null)
                          _DashbookDualThemeIcon(
                            dualTheme: widget.dualTheme!,
                            currentTheme: _currentTheme!,
                            onChangeTheme: (theme) =>
                                setState(() => _currentTheme = theme),
                          ),
                        if (widget.multiTheme != null)
                          DashbookIcon(
                            tooltip: 'Choose theme',
                            icon: Icons.palette,
                            onClick: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text('Theme chooser'),
                                  content: DropdownButton<ThemeData>(
                                    value: _currentTheme!,
                                    items: widget.multiTheme!.themes.entries
                                        .map((entry) => DropdownMenuItem(
                                              value: entry.value,
                                              child: Text(entry.key),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      if (value != null)
                                        setState(() => _currentTheme = value);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        if (kIsWeb && _currentChapter != null)
                          DashbookIcon(
                            tooltip: 'Share this example',
                            icon: Icons.share,
                            onClick: () {
                              final url =
                                  PlatformUtils.getChapterUrl(_currentChapter!);
                              Clipboard.setData(ClipboardData(text: url));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Link copied to your clipboard"),
                              ));
                            },
                          ),
                      ],
                    ),
                  ),
                  if (_currentView != CurrentView.STORIES)
                    Positioned(
                      top: 5,
                      left: 10,
                      child: DashbookIcon(
                        tooltip: 'Navigator',
                        icon: Icons.menu,
                        onClick: () =>
                            setState(() => _currentView = CurrentView.STORIES),
                      ),
                    ),
                  if (_currentView == CurrentView.STORIES)
                    Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      child: StoriesList(
                        stories: widget.stories,
                        selectedChapter: _currentChapter,
                        currentBookmark: _preferences.bookmarkedChapter,
                        onBookmarkChapter: (String bookmark) {
                          setState(() {
                            _preferences.bookmarkedChapter = bookmark;
                          });
                        },
                        onClearBookmark: () {
                          setState(() {
                            _preferences.bookmarkedChapter = null;
                          });
                        },
                        onCancel: () => setState(() => _currentView = null),
                        onSelectChapter: (chapter) {
                          setState(() {
                            _currentChapter = chapter;
                            _currentView = null;
                          });
                        },
                      ),
                    ),
                  if (_currentView == CurrentView.PROPERTIES &&
                      _currentChapter != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: PropertiesContainer(
                        currentChapter: _currentChapter!,
                        onCancel: () => setState(() => _currentView = null),
                        onPropertyChange: () {
                          setState(() {});
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

class _DashbookRightIconList extends StatelessWidget {
  final List<Widget> children;

  _DashbookRightIconList({
    required this.children,
  });

  double _rightIconTop(int index, BuildContext ctx) =>
      10.0 + index * iconSize(ctx);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: iconSize(context),
      child: Stack(children: [
        for (int index = 0; index < children.length; index++)
          Positioned(
            top: _rightIconTop(index, context),
            child: children[index],
          ),
      ]),
    );
  }
}

class _DashbookDualThemeIcon extends StatelessWidget {
  final _DashbookDualTheme dualTheme;
  final ThemeData currentTheme;
  final Function(ThemeData) onChangeTheme;

  _DashbookDualThemeIcon({
    required this.dualTheme,
    required this.currentTheme,
    required this.onChangeTheme,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkthemeSelected = dualTheme.dark == currentTheme;
    return DashbookIcon(
      tooltip: isDarkthemeSelected
          ? 'Change to light theme'
          : 'Change to dark theme',
      icon: isDarkthemeSelected ? Icons.nightlight_round : Icons.wb_sunny,
      onClick: () {
        if (isDarkthemeSelected) {
          onChangeTheme(dualTheme.light);
        } else {
          onChangeTheme(dualTheme.dark);
        }
      },
    );
  }
}
