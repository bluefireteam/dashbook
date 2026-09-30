import 'package:dashbook/dashbook.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/helpers.dart';

Dashbook _getDashbook() {
  final dashbook = Dashbook();

  dashbook.storiesOf('EdgeInsets').add('default', (ctx) {
    final value = ctx.edgeInsetsProperty(
      'edgeInsetsValue',
      const EdgeInsets.fromLTRB(1, 2, 3, 4),
    );

    final sides = [value.left, value.top, value.right, value.bottom];

    return Text(
      'Current: ${sides.map((side) => side.toStringAsFixed(1)).join(' ')}',
    );
  });

  return dashbook;
}

void main() {
  group('Properties - EdgeInsets', () {
    testWidgets('returns the default value on first render', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      expect(find.text('Current: 1.0 2.0 3.0 4.0'), findsOneWidget);
    });

    testWidgets('fits the properties panel on medium sized screens', (
      tester,
    ) async {
      tester.setScreenSize(const Size(800, 600));
      await tester.pumpDashbook(_getDashbook());

      await tester.openPropertiesPanel();

      expect(tester.takeException(), isNull);
    });

    testWidgets('can change a single side', (tester) async {
      tester.setScreenSize(const Size(2000, 1000));
      await tester.pumpDashbook(_getDashbook());

      await tester.openPropertiesPanel();

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextField, '2'), '2.5');
      await tester.tap(find.text('Got it'));
      await tester.pumpAndSettle();

      expect(find.text('Current: 1.0 2.5 3.0 4.0'), findsOneWidget);
    });

    testWidgets('can change all sides to the same value', (tester) async {
      tester.setScreenSize(const Size(2000, 1000));
      await tester.pumpDashbook(_getDashbook());

      await tester.openPropertiesPanel();

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextField, '1'), '8');
      await tester.tap(find.text('Got it'));
      await tester.pumpAndSettle();

      expect(find.text('Current: 8.0 8.0 8.0 8.0'), findsOneWidget);
    });

    testWidgets('does not accept invalid values', (tester) async {
      tester.setScreenSize(const Size(2000, 1000));
      await tester.pumpDashbook(_getDashbook());

      await tester.openPropertiesPanel();

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextField, '2'), 'two');
      await tester.tap(find.text('Got it'));
      await tester.pumpAndSettle();

      expect(find.text('Invalid values!'), findsOneWidget);
      expect(find.text('Current: 1.0 2.0 3.0 4.0'), findsOneWidget);
    });

    testWidgets('keeps the value when the dialog is dismissed', (tester) async {
      tester.setScreenSize(const Size(2000, 1000));
      await tester.pumpDashbook(_getDashbook());

      await tester.openPropertiesPanel();

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextField, '2'), '20');
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();

      expect(find.text('Set values:'), findsNothing);
      expect(find.text('Current: 1.0 2.0 3.0 4.0'), findsOneWidget);
    });
  });
}
