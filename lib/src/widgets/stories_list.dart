import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/helpers.dart';
import 'package:dashbook/src/widgets/icon.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:dashbook/src/widgets/link.dart';
import 'package:dashbook/src/widgets/side_bar_panel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef OnSelectChapter = Function(Chapter chapter);
typedef OnBookmarkChapter = Function(String chapter);

class StoriesList extends StatefulWidget {
  final List<Story> stories;
  final Chapter? selectedChapter;
  final OnSelectChapter onSelectChapter;
  final String? currentBookmark;
  final OnBookmarkChapter onBookmarkChapter;
  final VoidCallback onClearBookmark;
  final VoidCallback onCancel;
  final void Function(String) onUpdateFilter;
  final String currentFilter;
  final bool storyPanelPinned;
  final void Function() onStoryPinChange;

  const StoriesList({
    required this.stories,
    required this.currentBookmark,
    required this.onBookmarkChapter,
    required this.onClearBookmark,
    required this.onSelectChapter,
    required this.onCancel,
    required this.onUpdateFilter,
    required this.currentFilter,
    required this.storyPanelPinned,
    required this.onStoryPinChange,
    Key? key,
    this.selectedChapter,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StoriesListState();
  }
}

class _StoriesListState extends State<StoriesList> {
  late TextEditingController _filterTextController;
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _filter = widget.currentFilter;
    _filterTextController = TextEditingController()
      ..text = widget.currentFilter;

    _filterTextController.addListener(() {
      setState(() {
        _filter = _filterTextController.text;
      });
    });
  }

  @override
  void dispose() {
    _filterTextController.dispose();

    widget.onUpdateFilter(_filter);
    super.dispose();
  }

  void _pin(Chapter chapter) {
    if (chapter.id == widget.currentBookmark) {
      widget.onClearBookmark();
    } else {
      widget.onBookmarkChapter(chapter.id);
    }
  }

  bool _storyMatchesFilter(Story story) {
    if (_matchesFilter(story.name)) {
      return true;
    }

    for (final chapter in story.chapters) {
      if (_matchesFilter(chapter.name)) {
        return true;
      }
    }

    return false;
  }

  bool _matchesFilter(String value) =>
      value.isEmpty || value.toLowerCase().contains(_filter.toLowerCase());

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: SideBarPanel(
        title: 'Stories',
        titleIcon: DashbookIcon(
          key: kStoryPinIcon,
          tooltip: widget.storyPanelPinned ? 'Unpin' : 'Pin',
          icon: widget.storyPanelPinned
              ? Icons.push_pin
              : Icons.push_pin_outlined,
          onClick: widget.onStoryPinChange,
        ),
        width: sideBarSizeStory(context),
        onCloseKey: kStoriesCloseIcon,
        scrollViewKey: const PageStorageKey<String>('stories_list'),
        onCancel: widget.onCancel,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: TextField(
                key: kStoriesFilterField,
                decoration: const InputDecoration(
                  hintText: 'Filter stories and chapters',
                ),
                controller: _filterTextController,
              ),
            ),
            for (Story story in widget.stories)
              if (_storyMatchesFilter(story))
                ExpansionTile(
                  key: PageStorageKey('story_${story.name}'),
                  title: Text(
                    story.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  initiallyExpanded: true,
                  children: [
                    for (Chapter chapter in story.chapters)
                      if (_matchesFilter(story.name) ||
                          _matchesFilter(chapter.name))
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      widget.onSelectChapter(chapter);
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: Link(
                                      label: '  ${chapter.name}',
                                      textAlign: TextAlign.left,
                                      padding: const EdgeInsets.only(right: 8),
                                      textStyle: TextStyle(
                                        fontWeight: chapter.id ==
                                                widget.selectedChapter?.id
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                                Opacity(
                                  opacity: chapter.id == widget.currentBookmark
                                      ? 1
                                      : 0.05,
                                  child: DashbookIcon(
                                    icon: Icons.bookmark,
                                    onClick: () => _pin(chapter),
                                    tooltip:
                                        chapter.id == widget.currentBookmark
                                            ? 'Remove this chapter'
                                            : 'Bookmark this bookmark',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    const SizedBox(height: 10),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
