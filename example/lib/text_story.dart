import 'package:flutter/material.dart';

import 'package:dashbook/dashbook.dart';

void addTextStories(Dashbook dashbook) {
  dashbook
      .storiesOf('Text')
      .decorator(CenterDecorator())
      .add(
        'default',
        (ctx) {
          return Container(
            width: 300,
            padding: ctx.edgeInsetsProperty(
              "edge Insets",
              EdgeInsets.fromLTRB(1, 2, 3, 4),
            ),
            child: Text(
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
                fontSize: ctx.numberProperty("font size", 20),
                color: ctx.colorProperty(
                  "color",
                  Colors.red,
                ),
              ),
            ),
          );
        },
        codeLink: 'https://github.com/erickzanardo/dashbook/blob/master/example/lib/main.dart',
      )
      .add(
        'bold',
        (_) => Text(
          "Text",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      )
      .add(
        'color text',
        (_) => Text(
          "Text",
          style: TextStyle(
            color: Color(0xFF0000FF),
          ),
        ),
      );
}
