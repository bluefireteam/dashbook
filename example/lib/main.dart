import 'package:dashbook/dashbook.dart';
import 'package:example/stories.dart';
import 'package:example/text_story.dart';
import 'package:flutter/material.dart';

void main() {
  final dashbook = Dashbook.dualTheme(
    light: ThemeData(),
    dark: ThemeData.dark(),
    title: 'Dashbook Example',
  );

  addTextStories(dashbook);
  addStories(dashbook);

  runApp(dashbook);
}
