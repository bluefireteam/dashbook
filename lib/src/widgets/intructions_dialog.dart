import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class _InstructionsText extends StatelessWidget {
  final String instructions;

  _InstructionsText(this.instructions);

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    final codeTextColor = isDarkTheme ? Color(0xFFE5E5E5) : Color(0xFF858585);

    final codeBackGroundColor =
        isDarkTheme ? Color(0xFF858585) : Color(0xFFDEDEDE);

    return Markdown(
      selectable: true,
      data: instructions,
      styleSheet: MarkdownStyleSheet(
        codeblockDecoration: BoxDecoration(
          color: codeBackGroundColor,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        code: TextStyle(
          decoration: TextDecoration.none,
          backgroundColor: Color(0x00FFFFFF),
          color: codeTextColor,
        ),
      ),
    );
  }
}

class InstructionsDialog extends StatelessWidget {
  final String instructions;

  InstructionsDialog({
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: _InstructionsText(instructions),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
