import 'package:flutter/material.dart';

class PropertyDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;

  const PropertyDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(child: content),
      actions: actions,
    );
  }
}
