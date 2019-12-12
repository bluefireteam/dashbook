import 'package:flutter/material.dart';

import 'package:dashbook/dashbook.dart';

void main() {
  final dashbook = Dashbook();

  dashbook
      .storiesOf('Text')
      .decorator(CenterDecorator())
      .add('default', Text("Text"))
      .add('bold', Text("Text", style: TextStyle(fontWeight: FontWeight.bold)))
      .add('color text', Text("Text", style: TextStyle(color: Color(0xFF0000FF))));

  dashbook
      .storiesOf('RaisedButton')
      .decorator(CenterDecorator())
      .add('default', RaisedButton(child: Text('Ok'), onPressed: () {}));

  runApp(dashbook);
}

