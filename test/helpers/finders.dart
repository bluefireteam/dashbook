import 'package:dashbook/src/widgets/dashbook_icon.dart';
import 'package:flutter_test/flutter_test.dart';

extension CommonFindersX on CommonFinders {
  Finder dashbookIconByTooltip(String tooltip) {
    return byWidgetPredicate(
      (widget) => widget is DashbookIcon && widget.tooltip == tooltip,
    );
  }
}
