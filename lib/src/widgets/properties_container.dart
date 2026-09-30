import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/helpers.dart';
import 'package:dashbook/src/widgets/side_bar_panel.dart';
import 'package:material_ui/material_ui.dart';

class PropertiesContainer extends StatelessWidget {
  const PropertiesContainer({
    required this.currentChapter,
    required this.onPropertyChange,
    required this.onCancel,
    super.key,
  });

  final Chapter currentChapter;
  final VoidCallback onPropertyChange;
  final VoidCallback onCancel;

  bool _isVisible(Property<Object?> property) {
    final controlProperty = property.visibilityControlProperty;
    if (controlProperty == null) {
      return true;
    }

    final controlledBy = currentChapter.ctx.properties[controlProperty.key];
    return controlledBy == null ||
        controlledBy.getValue() == controlProperty.value;
  }

  @override
  Widget build(BuildContext context) {
    return SideBarPanel(
      title: 'Properties',
      width: sideBarSizeProperties(context),
      onCancel: onCancel,
      child: Column(
        children: [
          for (final property in currentChapter.ctx.properties.values)
            if (_isVisible(property))
              property.createPropertyEditor(
                onChanged: onPropertyChange,
                key: Key('${currentChapter.id}#${property.name}'),
              ),
        ],
      ),
    );
  }
}
