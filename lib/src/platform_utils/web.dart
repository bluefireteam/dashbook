import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/story_util.dart';
import 'package:web/web.dart' as web;

class PlatformUtils {
  PlatformUtils._();

  static String getChapterUrl(Chapter chapter) {
    final plainUrl =
        web.window.location.href.replaceFirst(web.window.location.hash, '');
    return '$plainUrl#/${Uri.encodeComponent(chapter.id)}';
  }

  static Chapter? getInitialChapter(List<Story> stories) {
    final hash = web.window.location.hash;

    if (hash.isNotEmpty) {
      final currentId = Uri.decodeComponent(hash.substring(2));

      return findChapter(currentId, stories);
    }
    return null;
  }
}
