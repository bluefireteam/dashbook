import 'package:flutter/material.dart';
import './side_bar_panel.dart';
import './link.dart';
import '../story.dart';

typedef OnSelectChapter = Function(Chapter chapter);

class StoriesList extends StatelessWidget {
  final List<Story> stories;
  final Chapter? selectedChapter;
  final OnSelectChapter onSelectChapter;
  final VoidCallback onCancel;

  StoriesList({
    required this.stories,
    required this.onSelectChapter,
    required this.onCancel,
    this.selectedChapter,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: SideBarPanel(
        title: 'Stories',
        onCancel: onCancel,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (Story story in stories)
              ExpansionTile(
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
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Link(
                            label: "  ${chapter.name}",
                            textAlign: TextAlign.left,
                            padding: EdgeInsets.zero,
                            height: 20,
                            textStyle: TextStyle(
                              fontWeight: chapter.id == selectedChapter?.id
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        onSelectChapter(chapter);
                      },
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
