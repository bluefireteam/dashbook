import 'package:dashbook/dashbook.dart';
import 'package:example/widgets/message_card.dart';
import 'package:flutter/material.dart';

void addStories(Dashbook dashbook) {
  dashbook.storiesOf('ElevatedButton').decorator(CenterDecorator()).add(
        'default',
        (ctx) => ElevatedButton(
          child: Text(
            ctx.listProperty('Label', 'Ok', ['Ok', 'Cancel', 'Other label']),
            style: TextStyle(
              fontSize: ctx.numberProperty('font size', 20),
            ),
          ),
          onPressed: () {},
        ),
      );

  dashbook.storiesOf('Checkbox').decorator(CenterDecorator()).add(
        'default',
        (ctx) => Checkbox(
          value: ctx.boolProperty('checked', true),
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
          'edge Insets',
          const EdgeInsets.fromLTRB(30, 10, 30, 50),
        ),
        child: Container(color: Colors.green),
      ),
    )
    ..add(
      'with border radius',
      (ctx) => Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.blue[300],
          borderRadius: ctx.borderRadiusProperty(
            'border radius',
            const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
      ),
    )
    ..add(
      'matching parent size',
      (ctx) => Container(color: Colors.blue[300]),
    );

  dashbook.storiesOf('MessageCard').decorator(CenterDecorator()).add(
        'default',
        (ctx) => MessageCard(
          message: ctx.textProperty('message', 'Some cool message'),
          type: ctx.listProperty(
            'type',
            MessageCardType.info,
            MessageCardType.values,
          ),
          errorColor: ctx.colorProperty(
            'errorColor',
            const Color(0xFFCC6941),
            visibilityControlProperty: ControlProperty(
              'type',
              MessageCardType.error,
            ),
          ),
          infoColor: ctx.colorProperty(
            'infoColor',
            const Color(0xFF5E89FF),
            visibilityControlProperty: ControlProperty(
              'type',
              MessageCardType.info,
            ),
          ),
        ),
      );
}
