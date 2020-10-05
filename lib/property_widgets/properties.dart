export 'bool_property.dart';
export 'color_property.dart';
export 'list_property.dart';
export 'number_property.dart';
export 'text_property.dart';

import 'package:flutter/material.dart';
import '../story.dart';

typedef PropertyChanged = void Function(Property);

class PropertyScaffold extends StatelessWidget {
  final String label;
  final Widget child;

  PropertyScaffold({
    this.label,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(label)),
          Expanded(flex: 6, child: child)
        ],
      ),
    );
  }
}
