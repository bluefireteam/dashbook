import 'package:material_ui/material_ui.dart';

bool isLargeScreen(BuildContext context) =>
    MediaQuery.sizeOf(context).width > 768;

double iconSize(BuildContext context) => isLargeScreen(context) ? 24 : 48;

double sideBarSizeProperties(BuildContext context) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  return isLargeScreen(context) ? screenWidth * 0.5 : screenWidth;
}

Future<T?> showPopup<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showDialog<T>(
    context: context,
    builder: builder,
    useRootNavigator: false,
  );
}
