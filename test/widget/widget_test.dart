// ignore_for_file: one_member_abstracts

import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers.dart';

abstract class _ChapterStub {
  void onCall(Chapter chapter);
}

class ChapterStub extends Mock implements _ChapterStub {}

Dashbook _getDashbook({OnChapterChange? onChapterChange}) {
  final dashbook = Dashbook(onChapterChange: onChapterChange);

  dashbook.storiesOf('Text').add('default', (_) {
    return const Text('Text story of the default chapter');
  }).add('bold', (_) {
    return const Text('Text story of the bold chapter');
  });

  return dashbook;
}

void main() {
  group('onChapterChange', () {
    setUpAll(() {
      registerFallbackValue(
        Chapter('', (_) => const SizedBox(), Story('story')),
      );
    });

    testWidgets('is called for the initial chapter', (tester) async {
      final stub = ChapterStub();
      await tester.pumpDashbook(_getDashbook(onChapterChange: stub.onCall));

      final value = verify(() => stub.onCall(captureAny())).captured;
      final chapter = value.first as Chapter;

      expect(chapter.name, equals('default'));
      expect(chapter.story.name, equals('Text'));
    });

    testWidgets('calls when a new chapter is selected', (tester) async {
      final stub = ChapterStub();
      await tester.pumpDashbook(_getDashbook(onChapterChange: stub.onCall));
      await tester.tap(find.byKey(kStoriesIcon));
      await tester.pumpAndSettle();

      await tester.tap(find.text('  bold'));
      await tester.pumpAndSettle();

      final value = verify(() => stub.onCall(captureAny())).captured;
      final chapter = value.last as Chapter;

      expect(chapter.name, equals('bold'));
      expect(chapter.story.name, equals('Text'));
    });
  });

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

    testWidgets('can select and apply a device to preview', (tester) async {
      final selectedDevice = Devices.android.mediumPhone;

      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      final dropDown = find
          .byWidgetPredicate((widget) => widget is DropdownButton<DeviceInfo>);

      await tester.tap(dropDown);
      await tester.pumpAndSettle();

      final dropdownItem = find.text(selectedDevice.name).last;
      await tester.ensureVisible(dropdownItem);
      await tester.pumpAndSettle();

      await tester.tap(dropdownItem);
      await tester.pumpAndSettle();

      final selectButton = find.text('Select');
      await tester.tap(selectButton);
      await tester.pumpAndSettle();

      expect(find.byType(DeviceFrame), findsOneWidget);
    });

    testWidgets(
        'rotate and hide frame are showed when a device to preview is selected',
        (tester) async {
      final selectedDevice = Devices.android.mediumPhone;

      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      final dropDown = find
          .byWidgetPredicate((widget) => widget is DropdownButton<DeviceInfo>);

      await tester.tap(dropDown);
      await tester.pumpAndSettle();

      final dropdownItem = find.text(selectedDevice.name).last;
      await tester.ensureVisible(dropdownItem);
      await tester.pumpAndSettle();

      await tester.tap(dropdownItem);
      await tester.pumpAndSettle();

      final selectButton = find.text('Select');
      await tester.tap(selectButton);
      await tester.pumpAndSettle();

      expect(find.byType(DeviceFrame), findsOneWidget);

      expect(find.byKey(kRotateIcon), findsOneWidget);
      expect(find.byKey(kHideFrameIcon), findsOneWidget);
    });

    testWidgets('can clear the device preview selected', (tester) async {
      final selectedDevice = Devices.android.mediumPhone;

      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      final dropDown = find
          .byWidgetPredicate((widget) => widget is DropdownButton<DeviceInfo>);

      await tester.tap(dropDown);
      await tester.pumpAndSettle();

      final dropdownItem = find.text(selectedDevice.name).last;
      await tester.ensureVisible(dropdownItem);
      await tester.pumpAndSettle();

      await tester.tap(dropdownItem);
      await tester.pumpAndSettle();

      final selectButton = find.text('Select');
      await tester.tap(selectButton);
      await tester.pumpAndSettle();

      expect(find.byType(DeviceFrame), findsOneWidget);

      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      final clearButton = find.text('Clear');
      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      expect(find.byType(DeviceFrame), findsNothing);
      expect(find.byKey(kRotateIcon), findsNothing);
      expect(find.byKey(kHideFrameIcon), findsNothing);
    });

    testWidgets('can hide device frame', (tester) async {
      final selectedDevice = Devices.android.mediumPhone;

      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      final dropDown = find
          .byWidgetPredicate((widget) => widget is DropdownButton<DeviceInfo>);

      await tester.tap(dropDown);
      await tester.pumpAndSettle();

      final dropdownItem = find.text(selectedDevice.name).last;
      await tester.ensureVisible(dropdownItem);
      await tester.pumpAndSettle();

      await tester.tap(dropdownItem);
      await tester.pumpAndSettle();

      final selectButton = find.text('Select');
      await tester.tap(selectButton);
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

    testWidgets('can rotate device preview', (tester) async {
      final selectedDevice = Devices.android.mediumPhone;

      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      final dropDown = find
          .byWidgetPredicate((widget) => widget is DropdownButton<DeviceInfo>);

      await tester.tap(dropDown);
      await tester.pumpAndSettle();

      final dropdownItem = find.text(selectedDevice.name).last;
      await tester.ensureVisible(dropdownItem);
      await tester.pumpAndSettle();

      await tester.tap(dropdownItem);
      await tester.pumpAndSettle();

      final selectButton = find.text('Select');
      await tester.tap(selectButton);
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
  });
}
