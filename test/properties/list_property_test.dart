import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

Dashbook _getDashbook() {
  final dashbook = Dashbook();

  dashbook.storiesOf('List').add('default', (ctx) {
    return Text(
      'Current: ${ctx.listProperty('listValue', 'ValueX', [
            'ValueX',
            'ValueY'
          ])}',
    );
  });

  return dashbook;
}

void main() {
  group('Properties - List', () {
    testWidgets('shows the property input', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      expect(find.byKey(kPropertiesIcon), findsOneWidget);
    });

    testWidgets('returns the default value on first render', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      expect(find.text('Current: ValueX'), findsOneWidget);
    });

    testWidgets('can change the property', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      await tester.openPropertiesPanel();

      await tester.tap(find.text('ValueX'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('ValueY').last);
      await tester.pumpAndSettle();

      expect(find.text('Current: ValueY'), findsOneWidget);
    });
  });
}
