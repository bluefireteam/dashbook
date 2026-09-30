import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/story_util.dart';
import 'package:web/web.dart' as web;

String getChapterUrl(Chapter chapter) {
  final plainUrl = web.window.location.href.split('#').first;
  return '$plainUrl#/${Uri.encodeComponent(chapter.id)}';
}

Chapter? getInitialChapter(List<Story> stories) {
  final encodedId = web.window.location.hash.replaceFirst(RegExp('^#/?'), '');
  if (encodedId.isEmpty) {
    return null;
  }

  try {
    return findChapter(Uri.decodeComponent(encodedId), stories);
    // ignore: avoid_catching_errors
  } on ArgumentError {
    return null;
  } on FormatException {
    return null;
  }
}
