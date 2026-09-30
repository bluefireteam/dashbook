import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/dashbook_icon.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/helpers.dart';

Finder _chapter(String name) {
  return find.descendant(
    of: find.byType(ExpansionTile),
    matching: find.text(name),
  );
}

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

      await tester.tap(find.text('bold'));
      await tester.pumpAndSettle();

      expect(find.text('Text story of the bold chapter'), findsOneWidget);
    });

    group('filter', () {
      testWidgets('when matching a story, shows all the chapters', (
        tester,
      ) async {
        await tester.pumpDashbook(_getDashbook());

        await tester.tap(find.byKey(kStoriesIcon));
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(kStoriesFilterField), 'Text');
        await tester.pumpAndSettle();

        expect(_chapter('default'), findsOneWidget);
        expect(_chapter('bold'), findsOneWidget);
      });

      testWidgets('when matching a chapter, shows only the relevant chapter', (
        tester,
      ) async {
        await tester.pumpDashbook(_getDashbook());

        await tester.tap(find.byKey(kStoriesIcon));
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(kStoriesFilterField), 'bold');
        await tester.pumpAndSettle();

        expect(_chapter('bold'), findsOneWidget);
        expect(_chapter('default'), findsNothing);
      });

      testWidgets('is kept when the stories list is reopened', (tester) async {
        await tester.pumpDashbook(_getDashbook());

        await tester.tap(find.byKey(kStoriesIcon));
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(kStoriesFilterField), 'bold');
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(kStoriesCloseIcon));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(kStoriesIcon));
        await tester.pumpAndSettle();

        expect(_chapter('bold'), findsOneWidget);
        expect(_chapter('default'), findsNothing);
      });
    });

    group('bookmark', () {
      testWidgets('can bookmark a chapter', (tester) async {
        await tester.pumpDashbook(_getDashbook());

        await tester.tap(find.byKey(kStoriesIcon));
        await tester.pumpAndSettle();

        await tester.tap(
          find.dashbookIconByTooltip('Bookmark this chapter').last,
        );
        await tester.pumpAndSettle();

        expect(find.dashbookIconByTooltip('Remove bookmark'), findsOneWidget);

        final preferences = await SharedPreferences.getInstance();
        expect(preferences.getString('bookmarked_chapter'), 'Text_bold');
      });

      testWidgets('can remove a bookmark', (tester) async {
        await tester.pumpDashbook(
          _getDashbook(),
          preferences: {'bookmarked_chapter': 'Text_bold'},
        );

        await tester.tap(find.byKey(kStoriesIcon));
        await tester.pumpAndSettle();

        await tester.tap(find.dashbookIconByTooltip('Remove bookmark'));
        await tester.pumpAndSettle();

        expect(find.dashbookIconByTooltip('Remove bookmark'), findsNothing);

        final preferences = await SharedPreferences.getInstance();
        expect(preferences.getString('bookmarked_chapter'), isNull);
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

    testWidgets('hides the stories pin icon on phones', (tester) async {
      tester.setScreenSize(const Size(500, 800));
      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kStoriesIcon));
      await tester.pumpAndSettle();

      expect(find.byKey(kStoryPinIcon), findsNothing);
    });

    testWidgets('can pin the stories list', (tester) async {
      await tester.pumpDashbook(_getDashbook());

      await tester.tap(find.byKey(kStoriesIcon));
      await tester.pumpAndSettle();

      expect(find.byKey(kStoryPinIcon), findsOneWidget);

      await tester.tap(find.byKey(kStoryPinIcon));
      await tester.pumpAndSettle();

      await tester.tap(find.text('bold'));
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
