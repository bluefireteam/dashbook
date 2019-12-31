import 'package:flutter/material.dart';

import 'package:dashbook/dashbook.dart';

void main() {
  final dashbook = Dashbook();

  dashbook
      .storiesOf('Text')
      .decorator(CenterDecorator())
      .add('default', (ctx) {
        return Text(
          ctx.textProperty("text", "Text Example").getValue(),
          style: TextStyle(
              fontSize: ctx.numberProperty("font size", 20).getValue(),
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth =
                    ctx.numberProperty("stroke width", 0).getValue()),
        );
      })
      .add('bold',
          (_) => Text("Text", style: TextStyle(fontWeight: FontWeight.bold)))
      .add('color text',
          (_) => Text("Text", style: TextStyle(color: Color(0xFF0000FF))));

  dashbook.storiesOf('RaisedButton').decorator(CenterDecorator()).add(
      'default',
      (ctx) => RaisedButton(
          child: Text(ctx.textProperty("Label", "Ok").getValue()),
          onPressed: () {}));

  runApp(dashbook);
}
