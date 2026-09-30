import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/dashbook_icon.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:dashbook/src/widgets/select_device/device_settings.dart';
import 'package:device_frame/device_frame.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/helpers.dart';

void main() {
  Dashbook getDashbook({
    void Function(DeviceSettingsData?)? onDeviceSettingsChanged,
  }) {
    final dashbook = Dashbook();

    dashbook.storiesOf('Testing').add('default', (context) {
      return Builder(
        builder: (context) {
          onDeviceSettingsChanged?.call(DeviceSettings.of(context).settings);
          return const Text('This is test');
        },
      );
    });

    return dashbook;
  }

  Future<void> openCustomSetup(WidgetTester tester) async {
    final customDeviceButtonLabel = find.text('Custom device');
    await tester.tap(customDeviceButtonLabel);
    await tester.pumpAndSettle();
  }

  group('Device settings', () {
    testWidgets('show select device settings', (tester) async {
      tester.setScreenSize(const Size(2000, 1000));
      await tester.pumpDashbook(getDashbook());
      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      expect(find.text('Select a device frame:'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is DropdownButton<DeviceInfo>,
        ),
        findsOneWidget,
      );

      final cancelButton = find.byKey(kDevicePreviewCloseIcon);
      expect(cancelButton, findsOneWidget);
      expect(tester.widget(cancelButton), isA<DashbookIcon>());

      final clearButtonLabel = find.text('Reset');
      expect(clearButtonLabel, findsOneWidget);
      expect(
        find.ancestor(
          of: clearButtonLabel,
          matching: find.byWidgetPredicate((widget) => widget is TextButton),
        ),
        findsOneWidget,
      );

      final customDeviceButtonLabel = find.text('Custom device');
      expect(customDeviceButtonLabel, findsOneWidget);
      expect(
        find.ancestor(
          of: customDeviceButtonLabel,
          matching: find.byWidgetPredicate(
            (widget) => widget is CheckboxListTile,
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets('When click in Custom Device button, '
        'should toggle to form to customize device info', (tester) async {
      tester.setScreenSize(const Size(2000, 1000));
      await tester.pumpDashbook(getDashbook());
      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      await openCustomSetup(tester);

      final toggleKey = find.byKey(kCustomDeviceToggle);
      final toggleWidget = tester.widget(toggleKey) as CheckboxListTile;
      expect(toggleWidget.value, isTrue);

      final formFields = ['Height', 'Width'];
      for (final label in formFields) {
        expect(
          find.ancestor(
            of: find.text(label),
            matching: find.byWidgetPredicate(
              (widget) => widget is TextFormField,
            ),
          ),
          findsOneWidget,
        );
      }
      final availablePlatforms = [TargetPlatform.android, TargetPlatform.iOS];
      for (final platform in availablePlatforms) {
        expect(
          find.ancestor(
            of: find.text(platform.name),
            matching: find.byWidgetPredicate((widget) => widget is TextButton),
          ),
          findsOneWidget,
        );
      }
    });

    testWidgets('Should customize a device info and return it', (tester) async {
      DeviceSettingsData? settings;
      tester.setScreenSize(const Size(2000, 1000));
      await tester.pumpDashbook(
        getDashbook(onDeviceSettingsChanged: (selected) => settings = selected),
      );
      await tester.pump();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      await openCustomSetup(tester);

      final formFields = ['Height', 'Width'];
      for (final label in formFields) {
        await tester.enterText(
          find.ancestor(
            of: find.text(label),
            matching: find.byWidgetPredicate(
              (widget) => widget is TextFormField,
            ),
          ),
          '1000',
        );
      }
      await tester.ensureVisible(find.text('iOS'));
      await tester.tap(find.text('iOS'));

      await tester.drag(find.byType(Slider), const Offset(20, 0));
      await tester.pumpAndSettle();

      expect(settings, isNotNull);
      expect(settings!.textScaleFactor, 1.15);
      expect(settings!.deviceInfo!.screenSize.width, 1000);
      expect(settings!.deviceInfo!.screenSize.height, 1000);
      expect(settings!.deviceInfo!.identifier.platform, TargetPlatform.iOS);
    });

    testWidgets('ignores custom sizes that are out of range', (tester) async {
      DeviceSettingsData? settings;
      tester.setScreenSize(const Size(2000, 1000));
      await tester.pumpDashbook(
        getDashbook(onDeviceSettingsChanged: (selected) => settings = selected),
      );
      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      await openCustomSetup(tester);

      final widthField = find.ancestor(
        of: find.text('Width'),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(widthField, '1000');
      await tester.enterText(widthField, '1');
      await tester.pumpAndSettle();

      expect(find.text('Try to use a value greater than 100'), findsOneWidget);
      expect(settings!.deviceInfo!.screenSize.width, 1000);
    });

    testWidgets('can reset while customizing a device', (tester) async {
      tester.setScreenSize(const Size(2000, 1000));
      await tester.pumpDashbook(getDashbook());
      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      await openCustomSetup(tester);

      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();

      expect(find.byType(DeviceFrame), findsNothing);
      expect(find.text('Select a device frame:'), findsOneWidget);
      expect(
        tester.widget<CheckboxListTile>(find.byKey(kCustomDeviceToggle)).value,
        isFalse,
      );
    });

    testWidgets('keeps the custom device when the panel is reopened', (
      tester,
    ) async {
      tester.setScreenSize(const Size(2000, 1000));
      await tester.pumpDashbook(getDashbook());
      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      await openCustomSetup(tester);

      await tester.tap(find.byKey(kDevicePreviewCloseIcon));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      expect(find.byType(DeviceFrame), findsOneWidget);
      expect(find.text('Width'), findsOneWidget);
      expect(
        tester.widget<CheckboxListTile>(find.byKey(kCustomDeviceToggle)).value,
        isTrue,
      );
    });
  });
}
