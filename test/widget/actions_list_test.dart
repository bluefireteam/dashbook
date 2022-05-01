import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

Dashbook _getDashbook() {
  final dashbook = Dashbook();

  dashbook.storiesOf('Toast').add('default', (context) {
    context.action('Show toast', (context) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hello')),
      );
    });

    return const Text('Use actions');
  });

  return dashbook;
}

void main() {
  group('Actions', () {
    testWidgets('shows the actions icon', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      expect(find.byKey(kActionsIcon), findsOneWidget);
    });

    testWidgets('can open the actions list', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kActionsIcon));
      await tester.pumpAndSettle();
      expect(find.text('Actions'), findsOneWidget);
    });

    testWidgets('can close the actions list', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kActionsIcon));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(kActionsCloseIcon));
      await tester.pumpAndSettle();

      expect(find.text('Actions'), findsNothing);
    });

    testWidgets('can tap an action', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kActionsIcon));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show toast'));
      await tester.pump();

      expect(find.text('Hello'), findsOneWidget);
    });
  });
}
