# Dashbook

<p align="center">
  <img alt="dashbook" width="600px" src="https://github.com/erickzanardo/dashbook/raw/main/media/dashbook-logo-typo.png">
</p>

Dashbook is a UI development tool for Flutter, it works as a development enviroment for the project widgets and also a showcase for common widgets on the app, it is heavly inspired by [Storybook](https://storybook.js.org/) library, so it should be very easy for people who has already used Storybook, to use Dashbook.

It currently supports both mobile and web, having a friendly layout built to work nice on web and large resolutions.

Have any questions or ideas? Join our [Discord](https://discord.gg/FCHGNZ4yxF).

## How to use

Add the dependency to your `pubspec.yaml`

```
dashbook: ^0.1.5
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

## Preview area

By default Dashbook will provide the whole screen area for the preview, which means that its controll icons will appear floating above the example.

That behavior can be changed with the use of the `usePreviewSafeArea` parameter on `Dashbook` constructors, when setting this parameter to `true`, Dashbook will make sure that its icons will not appear floating above the example creating a safe area for the example preview.

## Managing themes

Dashbook offers three of ways to let you change themes when viewing your stories. Dashbook iteself is built to use the provided theme to stylize its own UI, so whatever theme is provided, the Dashbook UI show works nice.

### Single theme

Using the default constructor of the Dashbook, use the optional `theme` parameter to set the theme.

```dart
final dashbook = Dashbook(theme: ThemeData());
```

### Dual theme

When your app has two theme, the `dualTheme` constructor can be used. Two parameters `light` and `dark` can be informed to set which `ThemeData` represents a light theme, and which represents the dark theme, an additional parameter `initWithLight` can be used to tell Dashbook which theme should be used initially (defaults to `true`).

When using this, Dashbook will present an icon for the user to toggle between light and dark themes

```dart
final dashbook = Dashbook.dualTheme(
  light: YourLightTheme(),
  dark: YourDarkTheme(),
);
```

### Multiple themes

When an app have more than two themes, the `multiTheme` contructor can be used. It receives a `themes` parameter, which is a `Map<String, ThemeData>`, and an optional parameter `initialTheme` to inform which theme should be used initially (defaults to the first entry of the map).

When using this, Dashbook will present an icon, which shows a modal with a dropdown menu to enable the user to choose between the informed themes

```dart
final dashbook = Dashbook.multiTheme(
  themes: {
    'theme1': Theme1(),
    'theme2': Theme2(),
    'theme3': Theme3(),
  }
);
```

### Visibility control properties

Some more complex Widgets may feature several fields, which can lead to a very long list of properties which will in turn can create a confusing example.

This can be improved by the use of visibility control properties. This API allows a property to be shown or hidden according to the value of another property.

For example, let's imagine a Widget which can show both an information and an error message, controlled by a property called type, this widget also allows the user to customize both the error and information color, with visibility control properties the error color property can be shown only when the type is error.

Example:

```dart
dashbook.storiesOf('MessageCard').decorator(CenterDecorator()).add(
    'default',
    (ctx) => MessageCard(
        message: ctx.textProperty('message', 'Some cool message'),
        type: ctx.listProperty('type', MessageCardType.info, MessageCardType.values),
        errorColor: ctx.colorProperty(
            'errorColor',
            const Color(0xFFCC6941),
            // this property will only be shown when type is error
            visibilityControlProperty: ControlProperty('type', MessageCardType.error),
        ),
        infoColor: ctx.colorProperty(
            'infoColor',
            const Color(0xFF5E89FF),
            // this property will only be shown when type is info 
            visibilityControlProperty: ControlProperty('type', MessageCardType.info),
        ),
    ),
);
```

### Example
![dashbook_13](https://user-images.githubusercontent.com/835641/109422625-1ac69800-79bb-11eb-8a08-62e9771a15e8.gif)

## Structure

Dashbook is just a widget, so it can be ran in any way wanted, as there is no required structure that must be followed, although, we do recommend the following approach:

 - Create a file named `main_dashbook.dart` on the root source of your project (e.g. `lib/main_dashbook.dart`)
 - Create the Dashbook instance inside that file, calling the `runApp` method in the end (look on the example above)
 - Run it with the command `flutter run -t lib/main_dashbook.dart`
