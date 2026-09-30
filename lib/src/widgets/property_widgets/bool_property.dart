import 'package:dashbook/dashbook.dart';
import 'package:material_ui/material_ui.dart';

class BoolProperty extends StatelessWidget {
  const new({required this.property, required this.onChanged, super.key});

  final Property<bool> property;
  final PropertyChanged onChanged;

  @override
  Widget build(BuildContext context) {
    return PropertyScaffold(
      tooltipMessage: property.tooltipMessage,
      label: property.name,
      child: Checkbox(
        value: property.getValue(),
        onChanged: (value) {
          property.value = value;
          onChanged();
        },
      ),
    );
  }
}
