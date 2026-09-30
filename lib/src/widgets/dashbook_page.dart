import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/device_size_extension.dart';
import 'package:dashbook/src/preferences.dart';
import 'package:dashbook/src/widgets/actions_container.dart';
import 'package:dashbook/src/widgets/dashbook_icon.dart';
import 'package:dashbook/src/widgets/device_settings_container.dart';
import 'package:dashbook/src/widgets/helpers.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:dashbook/src/widgets/preview_container.dart';
import 'package:dashbook/src/widgets/properties_container.dart';
import 'package:dashbook/src/widgets/stories_list.dart';
import 'package:dashbook/src/widgets/toolbar.dart';
import 'package:material_ui/material_ui.dart';

enum _Panel { stories, properties, actions, deviceSettings }

class DashbookPage extends StatefulWidget {
  const new({
    required this.stories,
    required this.preferences,
    required this.usePreviewSafeArea,
    required this.autoPinStoriesOnLargeScreen,
    this.initialChapter,
    this.onChapterChange,
    this.themeIcon,
    super.key,
  });

  final List<Story> stories;
  final DashbookPreferences preferences;
  final bool usePreviewSafeArea;
  final bool autoPinStoriesOnLargeScreen;
  final Chapter? initialChapter;
  final OnChapterChange? onChapterChange;
  final Widget? themeIcon;

  @override
  State<DashbookPage> createState() => _DashbookPageState();
}

class _DashbookPageState extends State<DashbookPage> {
  late Chapter? _currentChapter = widget.initialChapter;
  _Panel? _openPanel;
  String _storiesFilter = '';
  bool _storyPanelPinned = false;

  void _open(_Panel panel) {
    setState(() {
      _openPanel = panel;
      _storyPanelPinned = false;
    });
  }

  void _closePanel() {
    setState(() {
      _openPanel = null;
      _storyPanelPinned = false;
    });
  }

  void _selectChapter(Chapter chapter) {
    widget.onChapterChange?.call(chapter);
    setState(() {
      _currentChapter = chapter;
      if (!_storyPanelPinned) {
        _openPanel = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chapter = _currentChapter;
    // Building the chapter registers its properties and actions, so it has to
    // be done before anything that depends on them.
    final chapterWidget = chapter?.widget();
    final alwaysShowStories =
        widget.autoPinStoriesOnLargeScreen && context.isWideScreen;
    final showStories = _openPanel == _Panel.stories || alwaysShowStories;

    final Widget? sidePanel = switch (_openPanel) {
      _Panel.properties when chapter != null => PropertiesContainer(
        currentChapter: chapter,
        onCancel: _closePanel,
        onPropertyChange: () => setState(() {}),
      ),
      _Panel.actions when chapter != null => ActionsContainer(
        currentChapter: chapter,
        onCancel: _closePanel,
      ),
      _Panel.deviceSettings => DeviceSettingsContainer(onCancel: _closePanel),
      _ => null,
    };

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (showStories)
              Drawer(
                child: StoriesList(
                  stories: widget.stories,
                  storyPanelPinned: _storyPanelPinned,
                  selectedChapter: chapter,
                  currentBookmark: widget.preferences.bookmarkedChapter,
                  currentFilter: _storiesFilter,
                  storiesAreAlwaysShown: alwaysShowStories,
                  onStoryPinChange: () => setState(() {
                    _storyPanelPinned = !_storyPanelPinned;
                  }),
                  onUpdateFilter: (filter) => _storiesFilter = filter,
                  onBookmarkChanged: (chapterId) => setState(() {
                    widget.preferences.bookmarkedChapter = chapterId;
                  }),
                  onCancel: _closePanel,
                  onSelectChapter: _selectChapter,
                ),
              ),
            Expanded(
              child: Stack(
                children: [
                  if (chapter != null &&
                      chapterWidget != null &&
                      (context.isNotPhoneSize || _openPanel != _Panel.stories))
                    Positioned.fill(
                      key: ValueKey(chapter.id),
                      right: sidePanel != null && context.isNotPhoneSize
                          ? sideBarSizeProperties(context)
                          : 0,
                      child: PreviewContainer(
                        usePreviewSafeArea: widget.usePreviewSafeArea,
                        info: chapter.pinInfo ? chapter.info : null,
                        child: chapterWidget,
                      ),
                    ),
                  Positioned(
                    top: 0,
                    right: 10,
                    bottom: 0,
                    child: Toolbar(
                      chapter: chapter,
                      themeIcon: widget.themeIcon,
                      onOpenProperties: () => _open(_Panel.properties),
                      onOpenActions: () => _open(_Panel.actions),
                      onOpenDeviceSettings: () => _open(_Panel.deviceSettings),
                    ),
                  ),
                  if (!showStories)
                    Positioned(
                      top: 5,
                      left: 10,
                      child: DashbookIcon(
                        key: kStoriesIcon,
                        tooltip: 'Navigator',
                        icon: Icons.menu,
                        onPressed: () => _open(_Panel.stories),
                      ),
                    ),
                  if (sidePanel != null)
                    Positioned(top: 0, right: 0, bottom: 0, child: sidePanel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
