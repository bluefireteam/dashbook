import './story.dart';

Chapter? findChapter(String id, List<Story> stories) {
  for (var story in stories) {
    for (var chapter in story.chapters) {
      if (chapter.id == id) {
        return chapter;
      }
    }
  }
  return null;
}
