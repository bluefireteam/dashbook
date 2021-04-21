import 'package:flutter/material.dart';
import './property_widgets/properties.dart' as p;
import './side_bar_panel.dart';
import '../story.dart';

typedef OnPropertyChange = void Function();

class PropertiesContainer extends StatefulWidget {
  final Chapter currentChapter;
  final OnPropertyChange onPropertyChange;
  final VoidCallback onCancel;

  PropertiesContainer({
    required this.currentChapter,
    required this.onPropertyChange,
    required this.onCancel,
  });

  @override
  State createState() => _PropertiesContainerState();
}

class _PropertiesContainerState extends State<PropertiesContainer> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    for (var entry in widget.currentChapter.ctx.properties.entries) {
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

      final _propertyKey =
          Key("${widget.currentChapter.id}#${entry.value.name}");
      final _onChanged = (chapter) {
        setState(() {});
        widget.onPropertyChange();
      };

      if (entry.value is ListProperty) {
        children.add(
          p.ListPropertyWidget(
            property: entry.value as ListProperty,
            onChanged: _onChanged,
            key: _propertyKey,
          ),
        );
      } else if (entry.value is Property<String>) {
        children.add(
          p.TextProperty(
            property: entry.value as Property<String>,
            onChanged: _onChanged,
            key: _propertyKey,
          ),
        );
      } else if (entry.value is Property<double>) {
        children.add(
          p.NumberProperty(
            property: entry.value as Property<double>,
            onChanged: _onChanged,
            key: _propertyKey,
          ),
        );
      } else if (entry.value is Property<bool>) {
        children.add(
          p.BoolProperty(
            property: entry.value as Property<bool>,
            onChanged: _onChanged,
            key: _propertyKey,
          ),
        );
      } else if (entry.value is Property<Color>) {
        children.add(
          p.ColorProperty(
            property: entry.value as Property<Color>,
            onChanged: _onChanged,
            key: _propertyKey,
          ),
        );
      } else if (entry.value is Property<EdgeInsets>) {
        children.add(
          p.EdgeInsetsProperty(
            property: entry.value as Property<EdgeInsets>,
            onChanged: _onChanged,
            key: _propertyKey,
          ),
        );
      } else if (entry.value is Property<BorderRadius>) {
        children.add(
          p.BorderRadiusProperty(
            property: entry.value as Property<BorderRadius>,
            onChanged: _onChanged,
            key: _propertyKey,
          ),
        );
      }
    }
    return SideBarPanel(
      title: 'Properties',
      onCancel: widget.onCancel,
      child: Column(
        children: children,
      ),
    );
  }
}
