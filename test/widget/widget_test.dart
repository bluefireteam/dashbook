import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

Dashbook _getDashbook() {
  final dashbook = Dashbook();

  dashbook.storiesOf('Text').add('default', (_) {
    return Text('Text story of the default chapter');
  })
    ..add('bold', (_) {
      return Text('Text story of the bold chapter');
    });

  return dashbook;
}

void main() {
  group('Device preview', () {
    testWidgets('shows the device preview icon', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      expect(find.byKey(kDevicePreviewIcon), findsOneWidget);
      expect(find.byKey(kRotateIcon), findsNothing);
      expect(find.byKey(kHideFrameIcon), findsNothing);
    });

    testWidgets('can open the device preview dialog', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();
      expect(find.text('Select a device frame'), findsOneWidget);
    });

    testWidgets('can close the stories list', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Select a device frame'), findsNothing);
    });
  });
}
