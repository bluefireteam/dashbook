import 'package:example/text_story.dart';
import 'package:flutter/material.dart';

import 'package:dashbook/dashbook.dart';

void main() {
  final dashbook = Dashbook.dualTheme(
    light: ThemeData(),
    dark: ThemeData.dark(),
  );

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

  dashbook.storiesOf('Container').decorator(CenterDecorator()).add(
        'default',
        (ctx) => Container(
          color: Colors.blue[300],
          width: 300,
          height: 300,
        ),
      )
        ..add(
            'with padding',
            (ctx) => Container(
                  color: Colors.blue[300],
                  width: 300,
                  height: 300,
                  padding: ctx.edgeInsetsProperty(
                    "edge Insets",
                    EdgeInsets.fromLTRB(30, 10, 30, 50),
                  ),
                  child: Container(color: Colors.green),
                ))
        ..add(
            'with border radius',
            (ctx) => Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: ctx.borderRadiusProperty(
                        "border radius",
                        BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50))),
                  ),
                ));

  runApp(dashbook);
}
