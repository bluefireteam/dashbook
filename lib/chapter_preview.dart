import 'package:dashbook/story.dart';
import 'package:flutter/material.dart';

class ChapterPreview extends StatelessWidget {
  final Chapter currentChapter;

  ChapterPreview({this.currentChapter, Key key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return LayoutBuilder(
      builder: (_, constraints) => currentChapter.widget(constraints),
    );
  }
}
