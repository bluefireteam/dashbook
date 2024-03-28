import 'package:dashbook/dashbook.dart';

class PlatformUtils {
  PlatformUtils._();

  static String? baseUrl = 'https://freya.digitaldev.nl/';

  static String getChapterUrl(DashbookBrand brand, Chapter chapter) {
    return '$baseUrl#/${brand.path}/${chapter.story.path}/${chapter.path}';
  }

  static String normalizePathName(String name) {
    return name
        .replaceAll(' & ', '_')
        .replaceAll(' ', '_')
        .replaceAll('&', '')
        .toLowerCase();
  }
}
