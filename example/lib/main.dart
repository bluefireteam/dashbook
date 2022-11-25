import 'package:dashbook/dashbook.dart';
import 'package:example/stories.dart';
import 'package:example/text_story.dart';
import 'package:flutter/material.dart';

void main() {
  final dashbook = MultiBrandBookBuilder(
    title: 'Dashbook',
    brands: [
      DashbookBrand(
        name: 'Ajax',
        themeSettings: getThemes(TestBrand.ajax),
        iconBuilder: (
          BuildContext context,
          ScreenSize size,
        ) =>
            LogoImage(
          'ajax.webp',
          size: size,
        ),
      ),
      DashbookBrand(
        name: 'Groningen',
        themeSettings: getThemes(TestBrand.groningen),
        iconBuilder: (
          BuildContext context,
          ScreenSize size,
        ) =>
            LogoImage(
          'fc_groningen.png',
          size: size,
        ),
      ),
    ],
  );

  addTextStories(dashbook);
  addStories(dashbook);

  runApp(dashbook.build());
}

enum TestBrand {
  ajax,
  groningen,
}

class LogoImage extends StatelessWidget {
  const LogoImage(
    this.logo, {
    required this.size,
    this.selected = true,
    Key? key,
  }) : super(key: key);
  final String logo;
  final ScreenSize size;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final isSmall = size == ScreenSize.small;
    final sizeInPx = isSmall ? 48.0 : 72.0;
    return SizedBox(
      height: sizeInPx,
      width: sizeInPx,
      child: Padding(
        padding: EdgeInsets.all(isSmall ? 8.0 : 8.0),
        child: Opacity(
          opacity: selected ? 1.0 : 0.5,
          child: Image.asset(logo),
        ),
      ),
    );
  }
}

ThemeSettings getThemes(TestBrand brand) {
  switch (brand) {
    case TestBrand.ajax:
      final dualTheme = DashbookDualTheme(
        light: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red,
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
    case TestBrand.groningen:
      return ThemeSettings(
        theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
      );
  }
}
