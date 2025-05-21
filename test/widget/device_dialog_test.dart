import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/dashbook_icon.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:dashbook/src/widgets/select_device/device_settings.dart';
import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';
import '../helpers/helpers.dart';

void main() {
  Dashbook getDashbook({
    void Function(DeviceSettingsData?)? onDeviceSettingsChanged,
  }) {
    final dashbook = Dashbook();

    dashbook.storiesOf('Testing').add('default', (context) {
      return Builder(
        builder: (context) {
          onDeviceSettingsChanged?.call(
            DeviceSettings.of(context).settings,
          );
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
          matching:
              find.byWidgetPredicate((widget) => widget is CheckboxListTile),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'When click in Custom Device button, '
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
            matching:
                find.byWidgetPredicate((widget) => widget is TextFormField),
          ),
          findsOneWidget,
        );
      }
      final availablePlatforms = [TargetPlatform.android, TargetPlatform.iOS];
      for (final platform in availablePlatforms) {
        expect(
          find.ancestor(
            of: find.text(platform.toString().split('.').last),
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
        getDashbook(
          onDeviceSettingsChanged: (selected) async {
            settings = selected;
          },
        ),
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
            matching:
                find.byWidgetPredicate((widget) => widget is TextFormField),
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
/*
    /// There is an issue on mockingjay when the test uses showdialog with navigator
    /// Uncomment the test after the fix
    testWidgets('select one device', (tester) async {
      final selectedDevice = Devices.android.nexus9;

      final navigator = MockNavigator();

      await tester.pumpWidget(_pumpDeviceDialog(navigator: navigator));
      //   await tester.tap(find.text('ButtonTest'));
      await tester.pumpAndSettle();

      final dropDown = find
          .byWidgetPredicate((widget) => widget is DropdownButton<DeviceInfo>);

      await tester.tap(dropDown);
      await tester.pumpAndSettle();

      final dropdownItem = find.text(selectedDevice.name).last;
      await tester.ensureVisible(dropdownItem);
      await tester.pumpAndSettle();

      await tester.tap(dropdownItem, warnIfMissed: true);
      await tester.pumpAndSettle();

      final selectButton = find.text('Select');
      await tester.tap(selectButton);
      await tester.pumpAndSettle();

      verify(
        () => navigator.pop(selectedDevice),
      ).called(1);
    });*/
  });
}
