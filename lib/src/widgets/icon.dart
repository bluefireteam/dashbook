import 'package:flutter/material.dart';

import './helpers.dart';

class DashbookIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onClick;
  final String tooltip;

  DashbookIcon({
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
      child: Container(
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
