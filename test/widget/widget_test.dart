// ignore_for_file: one_member_abstracts

import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/keys.dart';
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
}
