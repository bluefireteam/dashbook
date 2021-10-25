import 'package:dashbook/src/widgets/helpers.dart';
import 'package:flutter/material.dart';

class DashbookIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onClick;
  final String tooltip;

  const DashbookIcon({
    required this.icon,
    required this.onClick,
    required this.tooltip,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = iconSize(context);
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: size,
        height: size,
        child: Listener(
          child: Icon(
            icon,
            size: size,
            color: Theme.of(context).iconTheme.color,
          ),
          onPointerUp: (_) => onClick.call(),
        ),
      ),
    );
  }
}
