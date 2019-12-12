# Dashbook

Dashbook is a UI development tool for Flutter, it works as a development enviroment for the project widgets and also a showcase for common widgets on the app, it is heavly inspired by [Storybook](https://storybook.js.org/) library, so it should be very easy for people who has already used Storybook, to use Dashbook.

## How to use

A `Dashbook` instance has a collection of the app widgets (Stories) and its variants (Chapters). Here you can see a very simple example of how to use it.

```dart
import 'package:flutter/material.dart';

import 'package:dashbook/dashbook.dart';

void main() {
  final dashbook = Dashbook();

  // Adds the Text widget stories
  dashbook
      .storiesOf('Text')
      // Decorators are easy ways to apply a common layout to all of the story chapters, here are using onde of Dashbook's decorators,
      // which will center all the widgets on the center of the screen
      .decorator(CenterDecorator())
      // The Widget story can have as many chapters as needed
      .add('default', Text("Text"))
      .add('bold', Text("Text", style: TextStyle(fontWeight: FontWeight.bold)))
      .add('color text', Text("Text", style: TextStyle(color: Color(0xFF0000FF))));

  dashbook
      .storiesOf('RaisedButton')
      .decorator(CenterDecorator())
      .add('default', RaisedButton(child: Text('Ok'), onPressed: () {}));

  // Since dashbook is a widget itself, you can just call runApp passing it as a parameter
  runApp(dashbook);
}
```

## Roadmap
 - Better support for themes and specific platform widgets
 - Property list for Chapters
