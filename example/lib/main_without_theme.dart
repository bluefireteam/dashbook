import 'package:dashbook/dashbook.dart';
import 'package:example/stories.dart';
import 'package:example/text_story.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  final dashbook = Dashbook(autoPinStoriesOnLargeScreen: true);

  addTextStories(dashbook);
  addStories(dashbook);

  runApp(dashbook);
}
