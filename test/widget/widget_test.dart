// ignore_for_file: one_member_abstracts

import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';

abstract class _ChapterStub {
  void onCall(Chapter chapter);
}

class ChapterStub extends Mock implements _ChapterStub {}

Dashbook _addStories(Dashbook dashbook) {
  dashbook
      .storiesOf('Text')
      .add('default', (ctx) {
        ctx.textProperty('text', 'Some text');
        return const Text('Text story of the default chapter');
      })
      .add('bold', (_) {
        return const Text('Text story of the bold chapter');
      });

  return dashbook;
}

Dashbook _getDashbook({OnChapterChange? onChapterChange}) {
  return _addStories(Dashbook(onChapterChange: onChapterChange));
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

      await tester.tap(find.text('bold'));
      await tester.pumpAndSettle();

      final value = verify(() => stub.onCall(captureAny())).captured;
      final chapter = value.last as Chapter;

      expect(chapter.name, equals('bold'));
      expect(chapter.story.name, equals('Text'));
    });
  });

  group('initial chapter', () {
    testWidgets('is the bookmarked chapter', (tester) async {
      await tester.pumpDashbook(
        _getDashbook(),
        preferences: {'bookmarked_chapter': 'Text_bold'},
      );

      expect(find.text('Text story of the bold chapter'), findsOneWidget);
    });

    testWidgets('is the first chapter when the bookmark no longer exists', (
      tester,
    ) async {
      await tester.pumpDashbook(
        _getDashbook(),
        preferences: {'bookmarked_chapter': 'Removed_chapter'},
      );

      expect(find.text('Text story of the default chapter'), findsOneWidget);
    });

    testWidgets('is the first chapter of the first story that has chapters', (
      tester,
    ) async {
      final dashbook = Dashbook()..storiesOf('Empty');

      await tester.pumpDashbook(_addStories(dashbook));

      expect(find.text('Text story of the default chapter'), findsOneWidget);
    });
  });

  group('toolbar', () {
    for (final size in const [Size(400, 800), Size(1600, 1000)]) {
      testWidgets('icons can be tapped over their whole area on a '
          '${size.width.toInt()} wide screen', (tester) async {
        tester.setScreenSize(size);
        await tester.pumpDashbook(_getDashbook());

        final icon = tester.getRect(find.byKey(kPropertiesIcon));
        expect(
          tester.getRect(find.byType(Scaffold)).contains(icon.topRight),
          isTrue,
        );

        await tester.tapAt(icon.bottomCenter - const Offset(0, 1));
        await tester.pumpAndSettle();

        expect(find.text('Properties'), findsOneWidget);
      });
    }

    testWidgets('can be scrolled when it does not fit the screen', (
      tester,
    ) async {
      tester.setScreenSize(const Size(400, 80));
      await tester.pumpDashbook(_getDashbook());

      await tester.ensureVisible(find.byKey(kDevicePreviewIcon));
      await tester.tap(find.byKey(kDevicePreviewIcon));
      await tester.pumpAndSettle();

      expect(find.text('Device settings'), findsOneWidget);
    });
  });

  group('preview safe area', () {
    testWidgets('is not used by default', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      final preview = find.text('Text story of the default chapter');
      expect(tester.getTopLeft(preview).dx, 0);
    });

    testWidgets('keeps the preview clear of the icons', (tester) async {
      await tester.pumpDashbook(
        _addStories(Dashbook(usePreviewSafeArea: true)),
      );

      final preview = find.text('Text story of the default chapter');
      final storiesIcon = tester.getRect(find.byKey(kStoriesIcon));
      expect(tester.getTopLeft(preview).dx, greaterThan(storiesIcon.right));
    });
  });

  group('themes', () {
    ThemeData currentTheme(WidgetTester tester) {
      return Theme.of(tester.element(find.byType(Scaffold)));
    }

    testWidgets('dual theme can toggle between light and dark', (tester) async {
      await tester.pumpDashbook(
        _addStories(
          Dashbook.dualTheme(light: ThemeData(), dark: ThemeData.dark()),
        ),
      );

      expect(currentTheme(tester).brightness, Brightness.light);

      await tester.tap(find.dashbookIconByTooltip('Change to dark theme'));
      await tester.pumpAndSettle();

      expect(currentTheme(tester).brightness, Brightness.dark);

      await tester.tap(find.dashbookIconByTooltip('Change to light theme'));
      await tester.pumpAndSettle();

      expect(currentTheme(tester).brightness, Brightness.light);
    });

    testWidgets('dual theme can start with the dark theme', (tester) async {
      await tester.pumpDashbook(
        _addStories(
          Dashbook.dualTheme(
            light: ThemeData(),
            dark: ThemeData.dark(),
            initWithLight: false,
          ),
        ),
      );

      expect(currentTheme(tester).brightness, Brightness.dark);
    });

    testWidgets('multi theme starts with the initial theme', (tester) async {
      await tester.pumpDashbook(
        _addStories(
          Dashbook.multiTheme(
            themes: {'light': ThemeData(), 'dark': ThemeData.dark()},
            initialTheme: 'dark',
          ),
        ),
      );

      expect(currentTheme(tester).brightness, Brightness.dark);
    });

    testWidgets('multi theme can choose a theme', (tester) async {
      await tester.pumpDashbook(
        _addStories(
          Dashbook.multiTheme(
            themes: {
              'light': ThemeData(),
              'same as light': ThemeData(),
              'dark': ThemeData.dark(),
            },
          ),
        ),
      );

      expect(currentTheme(tester).brightness, Brightness.light);

      await tester.tap(find.dashbookIconByTooltip('Choose theme'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('light'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('dark').last);
      await tester.pumpAndSettle();

      expect(find.text('Theme chooser'), findsNothing);
      expect(currentTheme(tester).brightness, Brightness.dark);
    });
  });
}
