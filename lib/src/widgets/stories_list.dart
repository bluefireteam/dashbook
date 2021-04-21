import 'package:dashbook/src/widgets/icon.dart';
import 'package:flutter/material.dart';
import './side_bar_panel.dart';
import './link.dart';
import '../story.dart';

typedef OnSelectChapter = Function(Chapter chapter);
typedef OnBookmarkChapter = Function(String chapter);

class StoriesList extends StatelessWidget {
  final List<Story> stories;
  final Chapter? selectedChapter;
  final OnSelectChapter onSelectChapter;
  final String? currentBookmark;
  final OnBookmarkChapter onBookmarkChapter;
  final VoidCallback onClearBookmark;
  final VoidCallback onCancel;

  StoriesList({
    required this.stories,
    required this.currentBookmark,
    required this.onBookmarkChapter,
    required this.onClearBookmark,
    required this.onSelectChapter,
    required this.onCancel,
    this.selectedChapter,
  });

  void _pin(Chapter chapter) {
    if (chapter.id == currentBookmark) {
      onClearBookmark();
    } else {
      onBookmarkChapter(chapter.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: SideBarPanel(
        title: 'Stories',
        scrollViewKey: PageStorageKey('stories_list'),
        onCancel: onCancel,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (Story story in stories)
              ExpansionTile(
                key: PageStorageKey('story_${story.name}'),
                title: Text(
                  story.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                initiallyExpanded: true,
                children: [
                  for (Chapter chapter in story.chapters)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  onSelectChapter(chapter);
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Link(
                                  label: "  ${chapter.name}",
                                  textAlign: TextAlign.left,
                                  padding: EdgeInsets.zero,
                                  height: 20,
                                  textStyle: TextStyle(
                                    fontWeight:
                                        chapter.id == selectedChapter?.id
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            if (true)
                              Opacity(
                                opacity: chapter.id == currentBookmark
                                  ? 1
                                  : 0.05,
                                child: DashbookIcon(
                                  icon: Icons.bookmark,
                                  onClick: () => _pin(chapter),
                                  tooltip: chapter.id == currentBookmark
                                    ? 'Remove this chapter'
                                    : 'Bookmark this bookmark',
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 10),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
