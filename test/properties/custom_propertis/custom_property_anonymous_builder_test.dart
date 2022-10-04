import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:dashbook/src/widgets/property_widgets/properties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers.dart';

Dashbook _getDashbookTextPropertyAnonymousBuilder() {
  final dashbook = Dashbook();

  dashbook.storiesOf('List').add('default', (context) {
    final textProperty = context.addProperty(
      Property<String>.withBuilder(
        'textValue',
        'ValueX',
        builder: (property, onChanged, key) => TextProperty(
          property: property,
          onChanged: onChanged,
          key: key,
        ),
      ),
    );

    return Text(
      'Current: $textProperty',
    );
  });

  return dashbook;
}

void main() {
  group('Custom Properties Anonymous Builder - Text', () {
    testWidgets('shows the property input', (tester) async {
      await tester.pumpDashbook(_getDashbookTextPropertyAnonymousBuilder());

      expect(find.byKey(kPropertiesIcon), findsOneWidget);
    });

    testWidgets('returns the default value on first render', (tester) async {
      await tester.pumpDashbook(_getDashbookTextPropertyAnonymousBuilder());

      expect(find.text('Current: ValueX'), findsOneWidget);
    });

    testWidgets('can change the property', (tester) async {
      await tester.pumpDashbook(_getDashbookTextPropertyAnonymousBuilder());

      await tester.openPropertiesPanel();

      await tester.enterText(find.text('ValueX'), 'ValueY');

      await tester.pumpAndSettle();

      expect(find.text('Current: ValueY'), findsOneWidget);
    });
  });
}
