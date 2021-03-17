import 'package:flutter/material.dart';

class PropertyDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;

  PropertyDialog({
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(_) {
    return AlertDialog(
        title: Text(this.title),
        content: SingleChildScrollView(child: this.content),
        actions: this.actions);
  }
}
