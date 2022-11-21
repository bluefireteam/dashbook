import 'package:dashbook/src/widgets/select_device/device_dialog.dart';
import 'package:dashbook/src/widgets/select_device/device_settings.dart';
import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

void main() {
  Widget _pumpDeviceDialog({
    MockNavigator? navigator,
    void Function(DeviceSettingsData?)? onSelect,
  }) =>
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return MockNavigatorProvider(
                navigator: navigator ?? MockNavigator(),
                child: ElevatedButton(
                  child: const Text('ButtonTest'),
                  onPressed: () async {
                    final result = await showDialog<DeviceSettingsData>(
                      context: context,
                      builder: (_) => const DeviceDialog(),
                    );
                    onSelect?.call(result);
                  },
                ),
              );
            },
          ),
        ),
      );

  Future<void> _openCustomSetup(WidgetTester tester) async {
    final customDeviceButtonLabel = find.text('Custom Device');
    await tester.tap(customDeviceButtonLabel);
    await tester.pumpAndSettle();
  }

  group('Device dialog', () {
    testWidgets('show select dialog', (tester) async {
      await tester.pumpWidget(_pumpDeviceDialog());
      await tester.tap(find.text('ButtonTest'));
      await tester.pumpAndSettle();

      expect(find.text('Select a device frame'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is DropdownButton<DeviceInfo>,
        ),
        findsOneWidget,
      );

      final selectButtonLabel = find.text('Select');
      expect(selectButtonLabel, findsOneWidget);
      expect(
        find.ancestor(
          of: selectButtonLabel,
          matching:
              find.byWidgetPredicate((widget) => widget is ElevatedButton),
        ),
        findsOneWidget,
      );

      final cancelButtonLabel = find.text('Cancel');
      expect(cancelButtonLabel, findsOneWidget);
      expect(
        find.ancestor(
          of: cancelButtonLabel,
          matching:
              find.byWidgetPredicate((widget) => widget is ElevatedButton),
        ),
        findsOneWidget,
      );

      final clearButtonLabel = find.text('Clear');
      expect(clearButtonLabel, findsOneWidget);
      expect(
        find.ancestor(
          of: clearButtonLabel,
          matching:
              find.byWidgetPredicate((widget) => widget is ElevatedButton),
        ),
        findsOneWidget,
      );

      final customDeviceButtonLabel = find.text('Custom Device');
      expect(customDeviceButtonLabel, findsOneWidget);
      expect(
        find.ancestor(
          of: customDeviceButtonLabel,
          matching:
              find.byWidgetPredicate((widget) => widget is OutlinedButton),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'When click in Custom Device button, '
        'should show a form to customize device info', (tester) async {
      await tester.pumpWidget(_pumpDeviceDialog());
      await tester.tap(find.text('ButtonTest'));
      await tester.pumpAndSettle();

      await _openCustomSetup(tester);

      expect(find.text('Custom Device'), findsNothing);
      final deviceListButtonLabel = find.text('Devices List');
      expect(
        find.ancestor(
          of: deviceListButtonLabel,
          matching:
              find.byWidgetPredicate((widget) => widget is OutlinedButton),
        ),
        findsOneWidget,
      );

      final customDeviceTitle = find.text('Choose your custom setup');
      expect(customDeviceTitle, findsOneWidget);

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
      DeviceSettingsData? result;
      await tester.pumpWidget(
        _pumpDeviceDialog(onSelect: (selected) async => result = selected),
      );
      await tester.tap(find.text('ButtonTest'));
      await tester.pumpAndSettle();

      await _openCustomSetup(tester);

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
      await tester.tap(find.text('iOS'));

      await tester.drag(find.byType(Slider), const Offset(50, 0));

      await tester.tap(find.text('Select'));

      expect(result, isNotNull);
      expect(result!.textScaleFactor, 1.15);
      expect(result!.deviceInfo!.screenSize.width, 1000);
      expect(result!.deviceInfo!.screenSize.height, 1000);
      expect(result!.deviceInfo!.identifier.platform, TargetPlatform.iOS);
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
