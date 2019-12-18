# Dashbook

Dashbook is a UI development tool for Flutter, it works as a development enviroment for the project widgets and also a showcase for common widgets on the app, it is heavly inspired by [Storybook](https://storybook.js.org/) library, so it should be very easy for people who has already used Storybook, to use Dashbook.

__Disclaimer__: This is still in development, suggestions, and PRs are welcome!

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

![Dashbook](https://user-images.githubusercontent.com/835641/70755334-5292e280-1d18-11ea-9a4e-ae56903eb938.gif)

## Structure

Dashbook is just a widget, so it can be ran in any way wanted, as there is no required structure that must be followed, although, we do recommend the following approach:

 - Create a file named `main_dashbook.dart` on the root source of your project (e.g. `lib/main_dashbook.dart`)
 - Create the Dashbook instance inside that file, calling the `runApp` method in the end (look on the example above)
 - Run it with the command `flutter run -t lib/main_dashbook.dart`

## Roadmap
 - Better support for themes and specific platform widgets
 - Property list for Chapters
 - Search on the stories list
 - Any other suggestions from the community
