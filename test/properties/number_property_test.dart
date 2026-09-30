import 'package:dashbook/dashbook.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/helpers.dart';

Dashbook _getDashbook() {
  final dashbook = Dashbook();

  dashbook.storiesOf('Number').add('default', (ctx) {
    final value = ctx.numberProperty('numberValue', 20);

    return Text('Current: ${value.toStringAsFixed(1)}');
  });

  return dashbook;
}

void main() {
  group('Properties - Number', () {
    testWidgets('returns the default value on first render', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      expect(find.text('Current: 20.0'), findsOneWidget);
    });

    testWidgets('can change the property', (tester) async {
      tester.setScreenSize(const Size(2000, 1000));
      await tester.pumpDashbook(_getDashbook());

      await tester.openPropertiesPanel();

      await tester.enterText(find.byType(TextFormField), '30');
      await tester.pumpAndSettle();

      expect(find.text('Current: 30.0'), findsOneWidget);
    });

    testWidgets('accepts decimal and negative numbers', (tester) async {
      tester.setScreenSize(const Size(2000, 1000));
      await tester.pumpDashbook(_getDashbook());

      await tester.openPropertiesPanel();

      await tester.enterText(find.byType(TextFormField), '-12.5');
      await tester.pumpAndSettle();

      expect(find.text('Current: -12.5'), findsOneWidget);
    });

    testWidgets('does not accept anything but numbers', (tester) async {
      tester.setScreenSize(const Size(2000, 1000));
      await tester.pumpDashbook(_getDashbook());

      await tester.openPropertiesPanel();

      await tester.enterText(find.byType(TextFormField), '7 apples');
      await tester.pumpAndSettle();

      expect(find.text('Current: 7.0'), findsOneWidget);
    });
  });
}
