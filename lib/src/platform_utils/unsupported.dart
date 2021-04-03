import 'package:dashbook/dashbook.dart';

class PlatformUtils {
  PlatformUtils._();

  static String getChapterUrl(Chapter chapter) {
    throw 'Platform not supported';
  }

  static Chapter? getInitialChapter(List<Story> stories) {
    return null;
  }
}
