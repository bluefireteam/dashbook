import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/platform_utils/platform_utils.dart';
import 'package:dashbook/src/preferences.dart';
import 'package:dashbook/src/story_util.dart';
import 'package:dashbook/src/widgets/device_dialog.dart';
import 'package:dashbook/src/widgets/helpers.dart';
import 'package:dashbook/src/widgets/icon.dart';
import 'package:dashbook/src/widgets/intructions_dialog.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:dashbook/src/widgets/preview_container.dart';
import 'package:dashbook/src/widgets/properties_container.dart';
import 'package:dashbook/src/widgets/stories_list.dart';
import 'package:device_frame/device_frame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

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
  final _DashbookDualTheme? _dualTheme;
  final _DashbookMultiTheme? _multiTheme;
  final String title;
  final bool usePreviewSafeArea;
  final GlobalKey<NavigatorState>? navigatorKey;

  Dashbook({
    Key? key,
    this.theme,
    this.title = '',
    this.usePreviewSafeArea = false,
    this.navigatorKey,
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
    this.navigatorKey,
  })  : _dualTheme = _DashbookDualTheme(
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
    this.navigatorKey,
  })  : _multiTheme =
            _DashbookMultiTheme(themes: themes, initialTheme: initialTheme),
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
}

class _DashbookState extends State<Dashbook> {
  Chapter? _currentChapter;
  CurrentView? _currentView;
  ThemeData? _currentTheme;
  late DashbookPreferences _preferences;
  bool _loading = true;
  String _storiesFilter = '';
  DeviceInfo? deviceInfo;
  Orientation deviceOrientation = Orientation.portrait;
  bool showDeviceFrame = true;
  bool _storyPanelPinned = false;

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
        return MaterialPageRoute<void>(
          builder: (context) {
            final chapterWidget = _currentChapter?.widget();
            return Scaffold(
              body: SafeArea(
                child: Row(
                  children: [
                    if (_currentView == CurrentView.stories)
                      Drawer(
                        child: StoriesList(
                          stories: widget.stories,
                          storyPanelPinned: _storyPanelPinned,
                          selectedChapter: _currentChapter,
                          currentBookmark: _preferences.bookmarkedChapter,
                          currentFilter: _storiesFilter,
                          onStoryPinChange: () {
                            setState(() {
                              _storyPanelPinned = !_storyPanelPinned;
                            });
                          },
                          onUpdateFilter: (value) {
                            _storiesFilter = value;
                          },
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
                          onCancel: () => setState(() {
                            _currentView = null;
                            _storyPanelPinned = false;
                          }),
                          onSelectChapter: (chapter) {
                            setState(() {
                              _currentChapter = chapter;
                              if (!_storyPanelPinned) {
                                _currentView = null;
                              }
                            });
                          },
                        ),
                      ),
                    Expanded(
                      child: Stack(
                        children: [
                          if (_currentChapter != null &&
                              (kIsWeb || _currentView != CurrentView.stories))
                            PreviewContainer(
                              key: Key(_currentChapter!.id),
                              usePreviewSafeArea: widget.usePreviewSafeArea,
                              isPropertiesOpen:
                                  _currentView == CurrentView.properties,
                              deviceInfo: deviceInfo,
                              deviceOrientation: deviceOrientation,
                              showDeviceFrame: showDeviceFrame,
                              child: chapterWidget!,
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
                                      () {
                                        _currentView = CurrentView.properties;
                                        _storyPanelPinned = false;
                                      },
                                    ),
                                  ),
                                if (_currentChapter?.info != null)
                                  DashbookIcon(
                                    tooltip: 'Instructions',
                                    icon: Icons.info,
                                    onClick: () {
                                      showDialog<void>(
                                        context: context,
                                        builder: (_) {
                                          return InstructionsDialog(
                                            instructions:
                                                _currentChapter!.info!,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                if (_currentChapter?.codeLink != null)
                                  DashbookIcon(
                                    tooltip: 'See code',
                                    icon: Icons.code,
                                    onClick: () =>
                                        _launchURL(_currentChapter!.codeLink!),
                                  ),
                                if (widget._dualTheme != null)
                                  _DashbookDualThemeIcon(
                                    dualTheme: widget._dualTheme!,
                                    currentTheme: _currentTheme!,
                                    onChangeTheme: (theme) =>
                                        setState(() => _currentTheme = theme),
                                  ),
                                if (widget._multiTheme != null)
                                  DashbookIcon(
                                    tooltip: 'Choose theme',
                                    icon: Icons.palette,
                                    onClick: () {
                                      showDialog<void>(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text('Theme chooser'),
                                          content: DropdownButton<ThemeData>(
                                            value: _currentTheme,
                                            items: widget
                                                ._multiTheme!.themes.entries
                                                .map(
                                                  (entry) => DropdownMenuItem(
                                                    value: entry.value,
                                                    child: Text(entry.key),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (value) {
                                              if (value != null) {
                                                setState(
                                                  () => _currentTheme = value,
                                                );
                                              }
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
                                      final url = PlatformUtils.getChapterUrl(
                                        _currentChapter!,
                                      );
                                      Clipboard.setData(
                                        ClipboardData(text: url),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Link copied to your clipboard',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                DashbookIcon(
                                  key: kDevicePreviewIcon,
                                  tooltip: 'Device preview',
                                  icon: Icons.phone_android_outlined,
                                  onClick: () async {
                                    final selectedDevice =
                                        await showDialog<DeviceInfo>(
                                      context: context,
                                      builder: (_) => DeviceDialog(
                                        currentSelection: deviceInfo,
                                      ),
                                    );

                                    setState(() => deviceInfo = selectedDevice);

                                    if (deviceInfo == null) {
                                      setState(() {
                                        deviceOrientation =
                                            Orientation.portrait;
                                      });
                                      setState(() => showDeviceFrame = true);
                                    }
                                  },
                                ),
                                if (deviceInfo != null)
                                  DashbookIcon(
                                    key: kRotateIcon,
                                    tooltip: 'Orientation',
                                    icon: Icons.screen_rotation_outlined,
                                    onClick: () => setState(() {
                                      deviceOrientation = deviceOrientation ==
                                              Orientation.portrait
                                          ? Orientation.landscape
                                          : Orientation.portrait;
                                    }),
                                  ),
                                if (deviceInfo != null)
                                  DashbookIcon(
                                    key: kHideFrameIcon,
                                    tooltip: 'Device frame',
                                    icon: Icons.mobile_off_outlined,
                                    onClick: () => setState(
                                      () => showDeviceFrame = !showDeviceFrame,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (_currentView != CurrentView.stories)
                            Positioned(
                              top: 5,
                              left: 10,
                              child: DashbookIcon(
                                key: kStoriesIcon,
                                tooltip: 'Navigator',
                                icon: Icons.menu,
                                onClick: () => setState(
                                  () => _currentView = CurrentView.stories,
                                ),
                              ),
                            ),
                          if (_currentView == CurrentView.properties &&
                              _currentChapter != null)
                            Positioned(
                              top: 0,
                              right: 0,
                              bottom: 0,
                              child: PropertiesContainer(
                                currentChapter: _currentChapter!,
                                onCancel: () =>
                                    setState(() => _currentView = null),
                                onPropertyChange: () {
                                  setState(() {});
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _DashbookRightIconList extends StatelessWidget {
  final List<Widget> children;

  const _DashbookRightIconList({
    required this.children,
  });

  double _rightIconTop(int index, BuildContext ctx) =>
      10.0 + index * iconSize(ctx);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: iconSize(context),
      child: Stack(
        children: [
          for (int index = 0; index < children.length; index++)
            Positioned(
              top: _rightIconTop(index, context),
              child: children[index],
            ),
        ],
      ),
    );
  }
}

class _DashbookDualThemeIcon extends StatelessWidget {
  final _DashbookDualTheme dualTheme;
  final ThemeData currentTheme;
  final Function(ThemeData) onChangeTheme;

  const _DashbookDualThemeIcon({
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
