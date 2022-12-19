import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/dashbook_icon.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension WidgetTesterExtension on WidgetTester {
  Future<void> pumpDashbook(
    Dashbook dashbook, {
    Map<String, Object> preferences = const {},
  }) async {
    SharedPreferences.setMockInitialValues(preferences);
    await pumpWidget(dashbook);
    await pumpAndSettle();
  }

  Future<void> openPropertiesPanel() async {
    await tap(find.byKey(kPropertiesIcon));
    await pumpAndSettle();
  }
}

extension CommonFindersX on CommonFinders {
  Finder dashbookIconByTooltip(String tooltip) {
    return byWidgetPredicate(
      (widget) => widget is DashbookIcon && widget.tooltip == tooltip,
    );
  }
}
