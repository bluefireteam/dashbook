import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:material_ui/material_ui.dart';

class InstructionsDialog extends StatelessWidget {
  const new({required this.instructions, super.key});

  final String instructions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(child: _InstructionsText(instructions)),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InstructionsText extends StatelessWidget {
  const new(this.instructions);

  final String instructions;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    final codeTextColor = isDarkTheme
        ? const Color(0xFFE5E5E5)
        : const Color(0xFF858585);

    final codeBackgroundColor = isDarkTheme
        ? const Color(0xFF858585)
        : const Color(0xFFDEDEDE);

    return Markdown(
      selectable: true,
      data: instructions,
      styleSheet: MarkdownStyleSheet(
        codeblockDecoration: BoxDecoration(
          color: codeBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        code: TextStyle(
          decoration: TextDecoration.none,
          backgroundColor: const Color(0x00FFFFFF),
          color: codeTextColor,
        ),
      ),
    );
  }
}
