import 'package:example/text_story.dart';
import 'package:flutter/material.dart';

import 'package:dashbook/dashbook.dart';

void main() {
  final dashbook = Dashbook.multiTheme(themes: {
    'light': ThemeData(),
    'gray': ThemeData.lerp(
      ThemeData(),
      ThemeData.dark(),
      0.3,
    ),
    'dark': ThemeData.dark(),
  });

  addTextStories(dashbook);

  dashbook.storiesOf('ElevatedButton').decorator(CenterDecorator()).add(
        'default',
        (ctx) => ElevatedButton(
          child: Text(
            ctx.listProperty("Label", "Ok", ["Ok", "Cancel", "Other label"]),
            style: TextStyle(
              fontSize: ctx.numberProperty("font size", 20),
            ),
          ),
          onPressed: () {},
        ),
      );

  dashbook.storiesOf('Checkbox').decorator(CenterDecorator()).add(
        'default',
        (ctx) => Checkbox(
          value: ctx.boolProperty("checked", true),
          onChanged: (_) {},
        ),
      );

  dashbook.storiesOf('Edge insets').decorator(CenterDecorator()).add(
        'default',
        (ctx) => Container(
          color: Colors.blue[300],
          padding: ctx.edgeInsetsProperty(
            "edge Insets",
            EdgeInsets.fromLTRB(30, 10, 30, 50),
          ),
          child: Text(
            "Text",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );

  dashbook.storiesOf('Border radius').decorator(CenterDecorator()).add(
        'default',
        (ctx) => Container(
          width: 300,
          height: 300,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.blue[300],
              borderRadius: ctx.borderRadiusProperty(
                  "border radius",
                  BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50)))),
          child: Text(
            "Text",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );

  runApp(dashbook);
}
