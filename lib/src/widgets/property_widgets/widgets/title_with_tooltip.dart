import 'package:flutter/material.dart';

class TitleWithTooltip extends StatelessWidget {
  final String label;
  final String tooltipMessage;

  const TitleWithTooltip({
    Key? key,
    required this.label,
    required this.tooltipMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        const SizedBox(width: 8),
        Tooltip(
          verticalOffset: 8,
          preferBelow: false,
          message: tooltipMessage,
          child: const Icon(
            Icons.info_outline_rounded,
            size: 16,
          ),
        ),
      ],
    );
  }
}
