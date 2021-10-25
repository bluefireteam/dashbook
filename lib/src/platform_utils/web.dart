// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/story_util.dart';

class PlatformUtils {
  PlatformUtils._();

  static String getChapterUrl(Chapter chapter) {
    final plainUrl =
        window.location.href.replaceFirst(window.location.hash, '');
    return '$plainUrl#/${Uri.encodeComponent(chapter.id)}';
  }

  static Chapter? getInitialChapter(List<Story> stories) {
    final hash = window.location.hash;

    if (hash.isNotEmpty) {
      final currentId = Uri.decodeComponent(hash.substring(2));

      return findChapter(currentId, stories);
    }
    return null;
  }
}
