import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/dashbook_icon.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:dashbook/src/widgets/side_bar_panel.dart';
import 'package:material_ui/material_ui.dart';

class StoriesList extends StatefulWidget {
  const new({
    required this.stories,
    required this.currentBookmark,
    required this.onBookmarkChanged,
    required this.onSelectChapter,
    required this.onCancel,
    required this.onUpdateFilter,
    required this.currentFilter,
    required this.storyPanelPinned,
    required this.onStoryPinChange,
    required this.storiesAreAlwaysShown,
    super.key,
    this.selectedChapter,
  });

  final List<Story> stories;
  final Chapter? selectedChapter;
  final ValueChanged<Chapter> onSelectChapter;
  final String? currentBookmark;
  final ValueChanged<String?> onBookmarkChanged;
  final VoidCallback onCancel;
  final ValueChanged<String> onUpdateFilter;
  final String currentFilter;
  final bool storyPanelPinned;
  final VoidCallback onStoryPinChange;
  final bool storiesAreAlwaysShown;

  @override
  State<StoriesList> createState() => _StoriesListState();
}

class _StoriesListState extends State<StoriesList> {
  late String _filter = widget.currentFilter;

  void _updateFilter(String filter) {
    setState(() => _filter = filter);
    widget.onUpdateFilter(filter);
  }

  bool _matchesFilter(String value) =>
      value.toLowerCase().contains(_filter.toLowerCase());

  bool _storyMatchesFilter(Story story) =>
      _matchesFilter(story.name) ||
      story.chapters.any((chapter) => _matchesFilter(chapter.name));

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: SideBarPanel(
        title: 'Stories',
        titleIcon: DashbookIcon(
          key: kStoryPinIcon,
          tooltip: widget.storyPanelPinned ? 'Unpin' : 'Pin',
          icon: widget.storyPanelPinned
              ? Icons.push_pin
              : Icons.push_pin_outlined,
          onPressed: widget.onStoryPinChange,
        ),
        onCloseKey: kStoriesCloseIcon,
        scrollViewKey: const PageStorageKey<String>('stories_list'),
        onCancel: widget.onCancel,
        sideBarIsAlwaysShown: widget.storiesAreAlwaysShown,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: TextFormField(
                key: kStoriesFilterField,
                initialValue: widget.currentFilter,
                decoration: const InputDecoration(
                  hintText: 'Filter stories and chapters',
                ),
                onChanged: _updateFilter,
              ),
            ),
            for (final story in widget.stories)
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
                    for (final chapter in story.chapters)
                      if (_matchesFilter(story.name) ||
                          _matchesFilter(chapter.name))
                        _ChapterTile(
                          chapter: chapter,
                          isSelected: chapter.id == widget.selectedChapter?.id,
                          isBookmarked: chapter.id == widget.currentBookmark,
                          onSelect: () => widget.onSelectChapter(chapter),
                          onBookmarkChanged: widget.onBookmarkChanged,
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

class _ChapterTile extends StatelessWidget {
  const new({
    required this.chapter,
    required this.isSelected,
    required this.isBookmarked,
    required this.onSelect,
    required this.onBookmarkChanged,
  });

  final Chapter chapter;
  final bool isSelected;
  final bool isBookmarked;
  final VoidCallback onSelect;
  final ValueChanged<String?> onBookmarkChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: onSelect,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    chapter.name,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? null : Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Opacity(
            opacity: isBookmarked ? 1 : 0.05,
            child: DashbookIcon(
              icon: Icons.bookmark,
              onPressed: () =>
                  onBookmarkChanged(isBookmarked ? null : chapter.id),
              tooltip: isBookmarked
                  ? 'Remove bookmark'
                  : 'Bookmark this chapter',
            ),
          ),
        ],
      ),
    );
  }
}
