import 'package:material_ui/material_ui.dart';

class TitleWithTooltip extends StatelessWidget {
  const new({required this.label, required this.tooltipMessage, super.key});

  final String label;
  final String tooltipMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(child: Text(label)),
        const SizedBox(width: 8),
        Tooltip(
          verticalOffset: 8,
          preferBelow: false,
          message: tooltipMessage,
          child: const Icon(Icons.info_outline_rounded, size: 16),
        ),
      ],
    );
  }
}
