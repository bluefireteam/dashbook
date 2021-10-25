import 'package:dashbook/dashbook.dart';

Chapter? findChapter(String id, List<Story> stories) {
  for (final story in stories) {
    for (final chapter in story.chapters) {
      if (chapter.id == id) {
        return chapter;
      }
    }
  }
  return null;
}
