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
    return SideBarPanel(
      title: 'Properties',
      onCancel: widget.onCancel,
      child: Column(
        children: [
          ...widget.currentChapter.ctx.properties.entries.map((entry) {
            final _propertyKey =
                Key("${widget.currentChapter.id}#${entry.value.name}");
            final _onChanged = (chapter) {
              setState(() {});
              widget.onPropertyChange();
            };
            if (entry.value is ListProperty) {
              return p.ListPropertyWidget(
                property: entry.value as ListProperty,
                onChanged: _onChanged,
                key: _propertyKey,
              );
            } else if (entry.value is Property<String>) {
              return p.TextProperty(
                property: entry.value as Property<String>,
                onChanged: _onChanged,
                key: _propertyKey,
              );
            } else if (entry.value is Property<double>) {
              return p.NumberProperty(
                property: entry.value as Property<double>,
                onChanged: _onChanged,
                key: _propertyKey,
              );
            } else if (entry.value is Property<bool>) {
              return p.BoolProperty(
                property: entry.value as Property<bool>,
                onChanged: _onChanged,
                key: _propertyKey,
              );
            } else if (entry.value is Property<Color>) {
              return p.ColorProperty(
                property: entry.value as Property<Color>,
                onChanged: _onChanged,
                key: _propertyKey,
              );
            } else if (entry.value is Property<EdgeInsets>) {
              return p.EdgeInsetsProperty(
                property: entry.value as Property<EdgeInsets>,
                onChanged: _onChanged,
                key: _propertyKey,
              );
            } else if (entry.value is Property<BorderRadius>) {
              return p.BorderRadiusProperty(
                property: entry.value as Property<BorderRadius>,
                onChanged: _onChanged,
                key: _propertyKey,
              );
            }
            return Container();
          }),
        ],
      ),
    );
  }
}
