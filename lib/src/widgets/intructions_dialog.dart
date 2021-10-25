import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class _InstructionsText extends StatelessWidget {
  final String instructions;

  const _InstructionsText(this.instructions);

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    final codeTextColor =
        isDarkTheme ? const Color(0xFFE5E5E5) : const Color(0xFF858585);

    final codeBackGroundColor =
        isDarkTheme ? const Color(0xFF858585) : const Color(0xFFDEDEDE);

    return Markdown(
      selectable: true,
      data: instructions,
      styleSheet: MarkdownStyleSheet(
        codeblockDecoration: BoxDecoration(
          color: codeBackGroundColor,
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

class InstructionsDialog extends StatelessWidget {
  final String instructions;

  const InstructionsDialog({
    Key? key,
    required this.instructions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: _InstructionsText(instructions),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
