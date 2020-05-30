import 'package:flutter/material.dart';

import 'package:dashbook/dashbook.dart';

void main() {
  final dashbook = Dashbook();

  dashbook
      .storiesOf('Text')
      .decorator(CenterDecorator())
      .add('default', (ctx) {
        return Container(
            width: 300,
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
                  fontSize: ctx.numberProperty("font size", 20)),
            ));
      })
      .add('bold',
          (_) => Text("Text", style: TextStyle(fontWeight: FontWeight.bold)))
      .add('color text',
          (_) => Text("Text", style: TextStyle(color: Color(0xFF0000FF))));

  dashbook.storiesOf('RaisedButton').decorator(CenterDecorator()).add(
        'default',
        (ctx) => RaisedButton(
          child: Text(
              ctx.listProperty("Label", "Ok", ["Ok", "Cancel", "Other label"]),
              style: TextStyle(fontSize: ctx.numberProperty("font size", 20))),
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

  runApp(dashbook);
}
