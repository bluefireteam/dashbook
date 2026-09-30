import 'package:material_ui/material_ui.dart';

class PropertyDialog extends StatelessWidget {
  const new({
    required this.title,
    required this.content,
    required this.actions,
    super.key,
  });

  final String title;
  final Widget content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(child: content),
      actions: actions,
    );
  }
}
