import 'package:dashbook/src/widgets/helpers.dart';
import 'package:flutter/material.dart';

class DashbookIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onClick;
  final String tooltip;

  const DashbookIcon({
    required this.icon,
    required this.onClick,
    required this.tooltip,
    super.key,
  });

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
      icon: Icon(icon),
      onPressed: onClick,
    );
  }
}
