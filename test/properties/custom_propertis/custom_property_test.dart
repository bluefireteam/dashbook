import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers.dart';

Dashbook _getDashbookTextPropertyAnonymousBuilder() {
  final dashbook = Dashbook();

  dashbook.storiesOf('List').add('default', (context) {
    final number = context.addProperty(CounterButtonProperty('Number'));
    return Text('Current: $number');
  });

  return dashbook;
}

void main() {
  group('Custom Properties From Property - Text', () {
    testWidgets('shows the property input', (tester) async {
      await tester.pumpDashbook(_getDashbookTextPropertyAnonymousBuilder());

      expect(find.byKey(kPropertiesIcon), findsOneWidget);
    });

    testWidgets('returns the default value on first render', (tester) async {
      await tester.pumpDashbook(_getDashbookTextPropertyAnonymousBuilder());

      expect(find.text('Current: 0'), findsOneWidget);
    });

    testWidgets('can change the property', (tester) async {
      await tester.pumpDashbook(_getDashbookTextPropertyAnonymousBuilder());

      await tester.openPropertiesPanel();

      await tester.tap(find.byType(OutlinedButton));

      await tester.pumpAndSettle();

      expect(find.text('Current: 1'), findsOneWidget);
    });
  });
}

class CounterButtonProperty extends Property<int> {
  CounterButtonProperty(super.name, [super.defaultValue = 0]);

  @override
  Widget createPropertyEditor({required PropertyChanged onChanged, Key? key}) {
    return PropertyScaffold(
      label: name,
      child: OutlinedButton(
        onPressed: () {
          value = getValue() + 1;
          onChanged();
        },
        child: Text(
          getValue().toString(),
        ),
      ),
    );
  }
}
