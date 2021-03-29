import 'package:example/stories.dart';
import 'package:example/text_story.dart';
import 'package:flutter/material.dart';

import 'package:dashbook/dashbook.dart';

void main() {
  final dashbook = Dashbook();

  addTextStories(dashbook);
  addStories(dashbook);

  runApp(dashbook);
}
