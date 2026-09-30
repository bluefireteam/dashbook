import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/dashbook_icon.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:device_frame/device_frame.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/helpers.dart';

Dashbook _getDashbook() {
  final dashbook = Dashbook();

  dashbook
      .storiesOf('Text')
      .add('default', (_) {
        return const Text('Text story of the default chapter');
      })
      .add('bold', (_) {
        return const Text('Text story of the bold chapter');
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

    testWidgets('can open the device preview panel', (tester) async {
      tester.setScreenSize(const Size(2000, 1000));
      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      expect(find.text('Select a device frame:'), findsOneWidget);
    });

    testWidgets('can close the device preview panel', (tester) async {
      tester.setScreenSize(const Size(2000, 1000));
      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(kDevicePreviewCloseIcon));
      await tester.pumpAndSettle();

      expect(find.text('Select a device frame:'), findsNothing);
    });

    testWidgets('can select and apply a device to preview', (tester) async {
      tester.setScreenSize(const Size(2000, 1000));
      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      final dropDown = find.byType(DropdownButton<DeviceInfo>);

      await tester.tap(dropDown);
      await tester.pumpAndSettle();

      final dropDownItemFinder = find.byType(DropdownMenuItem<DeviceInfo>);
      await tester.tap(dropDownItemFinder.first);
      await tester.pumpAndSettle();

      expect(find.byType(DeviceFrame), findsOneWidget);
    });

    testWidgets('can rotate device preview', (tester) async {
      tester.setScreenSize(const Size(2000, 1000));

      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      final dropDown = find.byType(DropdownButton<DeviceInfo>);

      await tester.tap(dropDown);
      await tester.pumpAndSettle();

      final dropDownItemFinder = find.byType(DropdownMenuItem<DeviceInfo>);
      await tester.tap(dropDownItemFinder.first);
      await tester.pumpAndSettle();

      expect(find.byType(DeviceFrame), findsOneWidget);

      await tester.tap(find.byKey(kRotateIcon));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (element) =>
              element is DeviceFrame &&
              element.orientation == Orientation.landscape,
        ),
        findsOneWidget,
      );
    });

    testWidgets('can select and apply a text scale factor', (tester) async {
      tester.setScreenSize(const Size(2000, 1000));
      await tester.pumpDashbook(_getDashbook());

      TextScaler textScaleFactor() => tester
          .widgetList<RichText>(find.byType(RichText))
          .firstWhere(
            (element) =>
                element.text.toPlainText() ==
                'Text story of the default chapter',
          )
          .textScaler;

      expect(textScaleFactor(), TextScaler.noScaling);

      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(Slider), const Offset(100, 0));
      await tester.pumpAndSettle();

      expect(textScaleFactor(), const TextScaler.linear(1.15));
    });

    testWidgets('can hide device frame', (tester) async {
      tester.setScreenSize(const Size(2000, 1000));

      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      final dropDown = find.byType(DropdownButton<DeviceInfo>);

      await tester.tap(dropDown);
      await tester.pumpAndSettle();

      final dropDownItemFinder = find.byType(DropdownMenuItem<DeviceInfo>);
      await tester.tap(dropDownItemFinder.first);
      await tester.pumpAndSettle();

      expect(find.byType(DeviceFrame), findsOneWidget);

      await tester.tap(find.byKey(kHideFrameIcon));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (element) => element is DeviceFrame && !element.isFrameVisible,
        ),
        findsOneWidget,
      );
    });

    testWidgets('can clear the device preview selected', (tester) async {
      tester.setScreenSize(const Size(2000, 1000));

      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      final dropDown = find.byType(DropdownButton<DeviceInfo>);

      await tester.tap(dropDown);
      await tester.pumpAndSettle();

      final dropDownItemFinder = find.byType(DropdownMenuItem<DeviceInfo>);
      await tester.tap(dropDownItemFinder.first);
      await tester.pumpAndSettle();

      expect(find.byType(DeviceFrame), findsOneWidget);

      final clearButton = find.text('Reset');
      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      expect(find.byType(DeviceFrame), findsNothing);

      expect(
        tester.widget<DashbookIcon>(find.byKey(kRotateIcon)).onPressed,
        isNull,
      );
      expect(
        tester.widget<DashbookIcon>(find.byKey(kHideFrameIcon)).onPressed,
        isNull,
      );
    });

    testWidgets(
      'rotate and hide frame are active when a device to preview is selected',
      (tester) async {
        tester.setScreenSize(const Size(2000, 1000));
        await tester.pumpDashbook(_getDashbook());

        await tester.tap(find.byKey(kDevicePreviewIcon));
        await tester.pumpAndSettle();

        final findRotate = find.byKey(kRotateIcon);
        final findFrameToggle = find.byKey(kHideFrameIcon);

        expect(tester.widget<DashbookIcon>(findRotate).onPressed, isNull);
        expect(tester.widget<DashbookIcon>(findFrameToggle).onPressed, isNull);

        final dropDown = find.byType(DropdownButton<DeviceInfo>);

        await tester.tap(dropDown);
        await tester.pumpAndSettle();

        final dropDownItemFinder = find.byType(DropdownMenuItem<DeviceInfo>);
        await tester.tap(dropDownItemFinder.first);
        await tester.pumpAndSettle();

        expect(find.byType(DeviceFrame), findsOneWidget);

        expect(tester.widget<DashbookIcon>(findRotate).onPressed, isNotNull);
        expect(
          tester.widget<DashbookIcon>(findFrameToggle).onPressed,
          isNotNull,
        );
      },
    );
  });
}
