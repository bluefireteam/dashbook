import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/icon.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

Dashbook _getDashbook() {
  final dashbook = Dashbook();

  dashbook.storiesOf('Text').add('default', (_) {
    return const Text('Text story of the default chapter');
  }).add('bold', (_) {
    return const Text('Text story of the bold chapter');
  });

  return dashbook;
}

void main() {
  group('Stories', () {
    testWidgets('shows the stories icon', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      expect(find.byKey(kStoriesIcon), findsOneWidget);
    });

    testWidgets('can open the stories list', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kStoriesIcon));
      await tester.pumpAndSettle();
      expect(find.text('Stories'), findsOneWidget);
    });

    testWidgets('can close the stories list', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kStoriesIcon));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(kStoriesCloseIcon));
      await tester.pumpAndSettle();

      expect(find.text('Stories'), findsNothing);
    });

    testWidgets('can select a chapter', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kStoriesIcon));
      await tester.pumpAndSettle();

      await tester.tap(find.text('  bold'));
      await tester.pumpAndSettle();

      expect(find.text('Text story of the bold chapter'), findsOneWidget);
    });

    group('filter', () {
      testWidgets('when matching a story, shows all the chapters',
          (tester) async {
        await tester.pumpDashbook(_getDashbook());

        await tester.tap(find.byKey(kStoriesIcon));
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(kStoriesFilterField), 'Text');
        await tester.pumpAndSettle();

        expect(find.text('  default'), findsOneWidget);
        expect(find.text('  bold'), findsOneWidget);
      });

      testWidgets('when matching a chapter, shows only the relevant chapter',
          (tester) async {
        await tester.pumpDashbook(_getDashbook());

        await tester.tap(find.byKey(kStoriesIcon));
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(kStoriesFilterField), 'bold');
        await tester.pumpAndSettle();

        expect(find.text('  bold'), findsOneWidget);
      });
    });

    testWidgets('shows the stories pin icon', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kStoriesIcon));
      await tester.pumpAndSettle();

      expect(find.byKey(kStoryPinIcon), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is DashbookIcon && widget.icon == Icons.push_pin_outlined,
        ),
        findsOneWidget,
      );
    });

    testWidgets('can pin the stories list', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kStoriesIcon));
      await tester.pumpAndSettle();

      expect(find.byKey(kStoryPinIcon), findsOneWidget);

      await tester.tap(find.byKey(kStoryPinIcon));
      await tester.pumpAndSettle();

      await tester.tap(find.text('  bold'));
      await tester.pumpAndSettle();

      expect(find.byKey(kStoryPinIcon), findsOneWidget);
    });

    testWidgets('can toggle pin stories list', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kStoriesIcon));
      await tester.pumpAndSettle();

      expect(find.byKey(kStoryPinIcon), findsOneWidget);

      await tester.tap(find.byKey(kStoryPinIcon));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (widget) => widget is DashbookIcon && widget.icon == Icons.push_pin,
        ),
        findsOneWidget,
      );

      await tester.tap(find.byKey(kStoryPinIcon));
      await tester.pumpAndSettle();

      expect(find.byKey(kStoryPinIcon), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is DashbookIcon && widget.icon == Icons.push_pin_outlined,
        ),
        findsOneWidget,
      );
    });
  });
}
