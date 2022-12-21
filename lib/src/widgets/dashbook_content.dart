import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/dashbook_config.dart';
import 'package:dashbook/src/device_size_extension.dart';
import 'package:dashbook/src/platform_utils/platform_utils.dart';
import 'package:dashbook/src/preferences.dart';
import 'package:dashbook/src/widgets/actions_container.dart';
import 'package:dashbook/src/widgets/helpers.dart';
import 'package:dashbook/src/widgets/icon.dart';
import 'package:dashbook/src/widgets/intructions_dialog.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:dashbook/src/widgets/preview_container.dart';
import 'package:dashbook/src/widgets/properties_container.dart';
import 'package:dashbook/src/widgets/select_device/device_dialog.dart';
import 'package:dashbook/src/widgets/stories_list.dart';
import 'package:dashbook/src/widgets/widget.dart';
import 'package:device_frame/device_frame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

typedef OnViewChange = void Function(CurrentView?);
typedef OnThemeChange = void Function(ThemeData);

class DashbookContent extends StatefulWidget {
  const DashbookContent({
    Key? key,
    required this.brand,
    required this.currentView,
    required this.currentChapter,
    required this.config,
    required this.onChapterChange,
    required this.onViewChange,
    required this.themeSettings,
    required this.onThemeChange,
  }) : super(key: key);

  final DashbookBrand brand;
  final CurrentView? currentView;
  final Chapter? currentChapter;
  final DashbookConfig config;
  final OnChapterChange onChapterChange;
  final OnViewChange onViewChange;
  final ThemeSettings themeSettings;
  final OnThemeChange onThemeChange;

  @override
  State<DashbookContent> createState() => _DashbookContentState();
}

class _DashbookContentState extends State<DashbookContent> {
  DashbookConfig get config => widget.config;
  DashbookPreferences get _preferences => config.preferences;
  Chapter? get _currentChapter => widget.currentChapter;
  CurrentView? get _currentView => widget.currentView;

  ThemeData get currentTheme => widget.themeSettings.currentTheme;
  DashbookDualTheme? get dualTheme => widget.themeSettings.dualTheme;
  DashbookMultiTheme? get multiTheme => widget.themeSettings.multiTheme;

  bool _storyPanelPinned = false;
  String _storiesFilter = '';

  DeviceInfo? deviceInfo;
  Orientation deviceOrientation = Orientation.portrait;
  bool showDeviceFrame = true;

  @override
  Widget build(BuildContext context) {
    final chapterWidget = _currentChapter?.widget();
    final alwaysShowStories =
        config.autoPinStoriesOnLargeScreen && context.isWideScreen;

    return SafeArea(
      child: Row(
        children: [
          if (_currentView == CurrentView.stories || alwaysShowStories)
            Drawer(
              child: StoriesList(
                title: widget.brand.name,
                stories: config.stories,
                storyPanelPinned: _storyPanelPinned,
                selectedChapter: _currentChapter,
                currentBookmark: _preferences.bookmarkedChapter,
                currentFilter: _storiesFilter,
                onStoryPinChange: () {
                  setState(() {
                    _storyPanelPinned = !_storyPanelPinned;
                  });
                },
                storiesAreAlwaysShown: alwaysShowStories,
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
                onCancel: () {
                  widget.onViewChange(null);
                  setState(() {
                    _storyPanelPinned = false;
                  });
                },
                onSelectChapter: (chapter) {
                  widget.onChapterChange(chapter);
                  if (!_storyPanelPinned) {
                    widget.onViewChange(null);
                  }
                },
              ),
            ),
          Expanded(
            child: Theme(
              data: widget.themeSettings.currentTheme,
              child: Stack(
                children: [
                  if (_currentChapter != null &&
                      (context.isNotPhoneSize ||
                          _currentView != CurrentView.stories))
                    PreviewContainer(
                      key: Key(_currentChapter!.id),
                      usePreviewSafeArea: config.usePreviewSafeArea,
                      isPropertiesOpen:
                          _currentView == CurrentView.properties ||
                              _currentView == CurrentView.actions,
                      deviceInfo: deviceInfo,
                      deviceOrientation: deviceOrientation,
                      showDeviceFrame: showDeviceFrame,
                      info: _currentChapter?.pinInfo == true
                          ? _currentChapter?.info
                          : null,
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
                            onClick: () {
                              widget.onViewChange(CurrentView.properties);
                              setState(() => _storyPanelPinned = false);
                            },
                          ),
                        if (_hasActions())
                          DashbookIcon(
                            key: kActionsIcon,
                            tooltip: 'Actions panel',
                            icon: Icons.play_arrow,
                            onClick: () {
                              widget.onViewChange(CurrentView.actions);
                              setState(() => _storyPanelPinned = false);
                            },
                          ),
                        if (_currentChapter?.info != null &&
                            _currentChapter?.pinInfo == false)
                          DashbookIcon(
                            tooltip: 'Instructions',
                            icon: Icons.info,
                            onClick: () {
                              showDialog<void>(
                                context: context,
                                builder: (_) {
                                  return InstructionsDialog(
                                    instructions: _currentChapter!.info!,
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
                        if (dualTheme != null)
                          _DashbookDualThemeIcon(
                            dualTheme: dualTheme!,
                            currentTheme: currentTheme,
                            onChangeTheme: widget.onThemeChange,
                          ),
                        if (multiTheme != null)
                          DashbookIcon(
                            tooltip: 'Choose theme',
                            icon: Icons.palette,
                            onClick: () {
                              showDialog<void>(
                                context: context,
                                useRootNavigator: false,
                                builder: (_) => AlertDialog(
                                  title: const Text('Theme chooser'),
                                  content: DropdownButton<ThemeData>(
                                    value: currentTheme,
                                    items: multiTheme!.themes.entries
                                        .map(
                                          (entry) => DropdownMenuItem(
                                            value: entry.value,
                                            child: Text(entry.key),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        widget.onThemeChange(value);
                                      }
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        if (!kIsWeb && PlatformUtils.baseUrl != null)
                          DashbookIcon(
                            tooltip: 'Share this example',
                            icon: Icons.share,
                            onClick: () {
                              final url = PlatformUtils.getChapterUrl(
                                widget.brand,
                                _currentChapter!,
                              );
                              Share.share(url);
                            },
                          ),
                        DashbookIcon(
                          key: kDevicePreviewIcon,
                          tooltip: 'Device preview',
                          icon: Icons.phone_android_outlined,
                          onClick: () async {
                            final selectedDevice = await showDialog<DeviceInfo>(
                              context: context,
                              builder: (_) => DeviceDialog(
                                currentSelection: deviceInfo,
                              ),
                            );

                            setState(() => deviceInfo = selectedDevice);

                            if (deviceInfo == null) {
                              setState(() {
                                deviceOrientation = Orientation.portrait;
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
                              deviceOrientation =
                                  deviceOrientation == Orientation.portrait
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
                  if (_currentView != CurrentView.stories && !alwaysShowStories)
                    Positioned(
                      top: 5,
                      left: 10,
                      child: DashbookIcon(
                        key: kStoriesIcon,
                        tooltip: 'Navigator',
                        icon: Icons.menu,
                        onClick: () => setState(
                          () => widget.onViewChange(CurrentView.stories),
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
                        onCancel: () => widget.onViewChange(null),
                        onPropertyChange: () {
                          setState(() {});
                        },
                      ),
                    ),
                  if (_currentView == CurrentView.actions &&
                      _currentChapter != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: ActionsContainer(
                        currentChapter: _currentChapter!,
                        onCancel: () => widget.onViewChange(null),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasProperties() => _currentChapter?.ctx.properties.isNotEmpty ?? false;
  bool _hasActions() => _currentChapter?.ctx.actions.isNotEmpty ?? false;

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await url_launcher.canLaunchUrl(uri)) {
      await url_launcher.launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
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
  final DashbookDualTheme dualTheme;
  final ThemeData currentTheme;
  final OnThemeChange onChangeTheme;

  const _DashbookDualThemeIcon({
    required this.dualTheme,
    required this.currentTheme,
    required this.onChangeTheme,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkThemeSelected = dualTheme.dark == currentTheme;
    return DashbookIcon(
      tooltip: isDarkThemeSelected
          ? 'Change to light theme'
          : 'Change to dark theme',
      icon: isDarkThemeSelected ? Icons.nightlight_round : Icons.wb_sunny,
      onClick: () {
        if (isDarkThemeSelected) {
          onChangeTheme(dualTheme.light);
        } else {
          onChangeTheme(dualTheme.dark);
        }
      },
    );
  }
}
