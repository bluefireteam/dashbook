import 'package:dashbook/dashbook.dart';
import 'package:material_ui/material_ui.dart';

class TextProperty extends StatelessWidget {
  const TextProperty({
    required this.property,
    required this.onChanged,
    super.key,
  });

  final Property<String> property;
  final PropertyChanged onChanged;

  @override
  Widget build(BuildContext context) {
    return PropertyScaffold(
      tooltipMessage: property.tooltipMessage,
      label: property.name,
      child: TextFormField(
        initialValue: property.getValue(),
        onChanged: (value) {
          property.value = value;
          onChanged();
        },
      ),
    );
  }
}
