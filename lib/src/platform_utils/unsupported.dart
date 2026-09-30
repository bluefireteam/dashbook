import 'package:dashbook/dashbook.dart';

String getChapterUrl(Chapter chapter) {
  throw UnsupportedError('Chapter links are only supported on the web');
}

Chapter? getInitialChapter(List<Story> stories) => null;
