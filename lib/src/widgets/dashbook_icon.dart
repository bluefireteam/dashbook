import 'package:dashbook/src/widgets/helpers.dart';
import 'package:material_ui/material_ui.dart';

class DashbookIcon extends StatelessWidget {
  const new({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final size = iconSize(context);
    return IconButton(
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      iconSize: size,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashRadius: size,
      constraints: BoxConstraints.tightFor(width: size, height: size),
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Icon(icon),
      onPressed: onPressed,
    );
  }
}
