import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

Dashbook _getDashbook() {
  final dashbook = Dashbook();

  dashbook.storiesOf('Options').add('default', (ctx) {
    return Text(
      ctx.optionsProperty('optionsProperty', 'ValueX', [
        PropertyOption('First option', 'ValueX'),
        PropertyOption('Second option', 'ValueY'),
      ]),
    );
  });

  return dashbook;
}

void main() {
  group('Properties - Options', () {
    testWidgets('shows the property input', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      expect(find.byKey(kPropertiesIcon), findsOneWidget);
    });

    testWidgets('returns the default value on first render', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      expect(find.text('ValueX'), findsOneWidget);
    });

    testWidgets('can change the property', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      await tester.openPropertiesPanel();

      await tester.tap(find.text('First option'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Second option').last);
      await tester.pumpAndSettle();

      expect(find.text('ValueY'), findsOneWidget);
    });
  });
}
