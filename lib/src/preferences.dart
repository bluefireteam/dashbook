import 'package:shared_preferences/shared_preferences.dart';

class DashbookPreferences {
  String? _bookmarkedChapter;

  static const _kBookmarkedChapter = 'bookmarked_chapter';

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();

    _bookmarkedChapter = preferences.getString(_kBookmarkedChapter);
  }

  void _setString(String key, String? value) async {
    final preferences = await SharedPreferences.getInstance();
    if (value == null) {
      preferences.remove(key);
    } else {
      preferences.setString(key, value);
    }
  }

  String? get bookmarkedChapter => _bookmarkedChapter;
  set bookmarkedChapter(String? value) {
    _bookmarkedChapter = value;
    _setString(_kBookmarkedChapter, value);
  }
}
