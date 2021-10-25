import 'package:flutter/material.dart';

typedef PropertyChanged = void Function();

class PropertyScaffold extends StatelessWidget {
  final String label;
  final Widget child;

  const PropertyScaffold({
    Key? key,
    required this.label,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(label)),
          Expanded(flex: 6, child: child)
        ],
      ),
    );
  }
}
