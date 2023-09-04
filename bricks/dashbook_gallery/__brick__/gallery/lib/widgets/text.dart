import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';

void addTextStories(Dashbook dashbook) {
  dashbook
      .storiesOf('Text')
      .decorator(CenterDecorator())
      .add(
        'default',
        (context) => Text(
          context.textProperty('text', 'Hello'),
        ),
      )
      .add(
        'with style',
        (_) => const Text(
          'Hello world',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
      .add(
        'with overflow',
        (_) => const SizedBox(
          width: 100,
          child: Text(
            'Hello world'
            'Hello world'
            'Hello world'
            'Hello world'
            'Hello world'
            'Hello world'
            'Hello world'
            'Hello world'
            'Hello world'
            'Hello world'
            'Hello world'
            'Hello world'
            'Hello world',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
}
