import 'package:dashbook/src/widgets/device_dialog.dart';
import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

void main() {
  Widget _pumpDeviceDialog({MockNavigator? navigator}) => MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return MockNavigatorProvider(
                navigator: navigator ?? MockNavigator(),
                child: ElevatedButton(
                  child: const Text('ButtonTest'),
                  onPressed: () => showDialog<DeviceInfo>(
                    context: context,
                    builder: (_) => const DeviceDialog(),
                  ),
                ),
              );
            },
          ),
        ),
      );

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
