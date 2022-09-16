import 'package:dashbook/dashbook.dart';
import 'package:example/stories.dart';
import 'package:example/text_story.dart';
import 'package:flutter/material.dart';

void main() {
  final dashbook = MultiBrandBookBuilder(
    brands: [
      DashbookBrand(
        name: 'love',
        themeSettings: getThemes(TestBrand.love),
        icon: Icon(Icons.favorite),
      ),
      DashbookBrand(
        name: 'hate',
        themeSettings: getThemes(TestBrand.hate),
        icon: Icon(Icons.heart_broken_outlined),
      ),
    ],
  );

  addTextStories(dashbook);
  addStories(dashbook);

  runApp(dashbook.build());
}

enum TestBrand {
  love,
  hate,
}

ThemeSettings getThemes(TestBrand brand) {
  switch (brand) {
    case TestBrand.love:
      final dualTheme = DashbookDualTheme(
        light: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red,
            brightness: Brightness.light,
          ),
        ),
        dark: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red,
            brightness: Brightness.dark,
          ),
        ),
      );
      return ThemeSettings(dualTheme: dualTheme);
    case TestBrand.hate:
      return ThemeSettings(
        theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        ),
      );
  }
}
