import 'package:flutter/material.dart';
import './side_bar_panel.dart';
import './link.dart';
import '../story.dart';

typedef OnSelectChapter = Function(Chapter chapter);
class StoriesList extends StatelessWidget {
  final List<Story> stories;
  final Chapter selectedChapter;
  final OnSelectChapter onSelectChapter;
  final VoidCallback onCancel;

  StoriesList({
    this.stories,
    this.selectedChapter,
    this.onSelectChapter,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return SideBarPanel(
      title: 'Stories',
      onCancel: onCancel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (Story story in stories)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  story.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                for (Chapter chapter in story.chapters)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Link(
                      label: "  ${chapter.name}",
                      textAlign: TextAlign.left,
                      padding: EdgeInsets.zero,
                      height: 20,
                      textStyle: TextStyle(
                        fontWeight: chapter.id == selectedChapter.id
                            ? FontWeight.bold
                            : FontWeight.normal,
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
    );
  }
}
