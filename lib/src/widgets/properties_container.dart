import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/helpers.dart';
import 'package:dashbook/src/widgets/side_bar_panel.dart';
import 'package:flutter/material.dart';

typedef OnPropertyChange = void Function();

class PropertiesContainer extends StatefulWidget {
  final Chapter currentChapter;
  final OnPropertyChange onPropertyChange;
  final VoidCallback onCancel;

  const PropertiesContainer({
    required this.currentChapter,
    required this.onPropertyChange,
    required this.onCancel,
    super.key,
  });

  @override
  State createState() => _PropertiesContainerState();
}

class _PropertiesContainerState extends State<PropertiesContainer> {
  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (final entry in widget.currentChapter.ctx.properties.entries) {
      // Check if this property is controlled by another one and if so
      // we only add it to the list if the values matches
      final visibilityControlProperty = entry.value.visibilityControlProperty;
      if (visibilityControlProperty != null) {
        final controlledByProperty =
            widget.currentChapter.ctx.properties[visibilityControlProperty.key];
        if (controlledByProperty != null) {
          if (controlledByProperty.getValue() !=
              visibilityControlProperty.value) {
            continue;
          }
        }
      }

      final propertyKey =
          Key('${widget.currentChapter.id}#${entry.value.name}');
      final onChanged = () {
        setState(() {});
        widget.onPropertyChange();
      };

      children.add(
        entry.value.createPropertyEditor(
          onChanged: onChanged,
          key: propertyKey,
        ),
      );
    }
    return SideBarPanel(
      title: 'Properties',
      width: sideBarSizeProperties(context),
      onCancel: widget.onCancel,
      child: Column(
        children: children,
      ),
    );
  }
}
