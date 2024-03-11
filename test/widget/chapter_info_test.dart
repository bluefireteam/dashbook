import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';
import '../helpers/helpers.dart';

Dashbook _getDashbookWithIconInfo() {
  final dashbook = Dashbook();

  dashbook.storiesOf('Text').add(
        'default',
        (context) => const SizedBox(),
        info: 'This is some info',
      );

  return dashbook;
}

Dashbook _getDashbookWithPinnedInfo() {
  final dashbook = Dashbook();

  dashbook.storiesOf('Text').add(
        'default',
        (context) => const SizedBox(),
        info: 'Behold! The info is already upon you!',
        pinInfo: true,
      );

  return dashbook;
}

void main() {
  group('Chapter Info', () {
    testWidgets('shows the info icon', (tester) async {
      await tester.pumpDashbook(_getDashbookWithIconInfo());
      expect(
        find.dashbookIconByTooltip('Instructions'),
        findsOneWidget,
      );
    });

    testWidgets(
      'show the info dialog when the icon is clicked',
      (tester) async {
        tester.setScreenSize(const Size(2000, 1000));
        await tester.pumpDashbook(_getDashbookWithIconInfo());

        await tester.tap(
          find.dashbookIconByTooltip('Instructions'),
        );

        await tester.pumpAndSettle();
        expect(find.text('This is some info'), findsOneWidget);
      },
    );

    testWidgets(
      'show the info dialog when the icon is clicked',
      (tester) async {
        await tester.pumpDashbook(_getDashbookWithPinnedInfo());

        await tester.pumpAndSettle();
        expect(
          find.text('Behold! The info is already upon you!'),
          findsOneWidget,
        );
      },
    );
  });
}
