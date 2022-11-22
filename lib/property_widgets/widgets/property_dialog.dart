import 'package:alkami_core_dependencies/alkami_core_dependencies.dart';

class PropertyDialog extends StatelessWidget {
  final String? title;
  final Widget? content;
  final List<Widget>? actions;

  PropertyDialog({this.title, this.content, this.actions});

  @override
  Widget build(_) {
    return AlertDialog(
        title: Text(this.title!),
        content: SingleChildScrollView(child: this.content),
        actions: this.actions);
  }
}
