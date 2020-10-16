# Dashbook

Dashbook is a UI development tool for Flutter, it works as a development enviroment for the project widgets and also a showcase for common widgets on the app, it is heavly inspired by [Storybook](https://storybook.js.org/) library, so it should be very easy for people who has already used Storybook, to use Dashbook.

It currently supports both mobile and web, having a friendly layout built to work nice on web and large resolutions.

__Disclaimer__: This is an early version, more features should be coming soon, suggestions, and PRs are welcome!

## How to use

Add the dependency to your `pubspec.ymal`


```
dashbook: ^0.0.9
```

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
      .add('default', (ctx) {
        return Container(width: 300, child: Text(
          ctx.textProperty("text", "Text Example"),
          textAlign: ctx.listProperty(
              "text align",
              TextAlign.center,
              TextAlign.values,
          ),
          textDirection: ctx.listProperty(
              "text direction",
              TextDirection.rtl,
              TextDirection.values,
          ),
          style: TextStyle(
              fontWeight: ctx.listProperty(
                  "font weight",
                  FontWeight.normal,
                  FontWeight.values,
              ),
              fontStyle: ctx.listProperty(
                  "font style",
                  FontStyle.normal,
                  FontStyle.values,
              ),
              fontSize: ctx.numberProperty("font size", 20)),
        ));
      });

  dashbook
      .storiesOf('RaisedButton')
      .decorator(CenterDecorator())
      .add('default', (ctx) => RaisedButton(child: Text('Ok'), onPressed: () {}));

  // Since dashbook is a widget itself, you can just call runApp passing it as a parameter
  runApp(dashbook);
}
```

### Mobile example
![Dashbook](https://user-images.githubusercontent.com/835641/88855642-9106e000-d1c9-11ea-8e5f-59e994a7fa03.gif)

### Web example
![Dashbook](https://user-images.githubusercontent.com/835641/88855646-92380d00-d1c9-11ea-8df4-74136bf18728.gif)

## Structure

Dashbook is just a widget, so it can be ran in any way wanted, as there is no required structure that must be followed, although, we do recommend the following approach:

 - Create a file named `main_dashbook.dart` on the root source of your project (e.g. `lib/main_dashbook.dart`)
 - Create the Dashbook instance inside that file, calling the `runApp` method in the end (look on the example above)
 - Run it with the command `flutter run -t lib/main_dashbook.dart`

## Roadmap
 - Better support for themes and specific platform widgets
 - ~~Property list for Chapters~~
 - Search on the stories list
 - Any other suggestions from the community
