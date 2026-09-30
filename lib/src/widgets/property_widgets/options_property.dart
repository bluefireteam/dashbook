import 'package:dashbook/dashbook.dart';
import 'package:material_ui/material_ui.dart';

class OptionsPropertyWidget<T> extends StatelessWidget {
  const OptionsPropertyWidget({
    required this.property,
    required this.onChanged,
    super.key,
  });

  final OptionsProperty<T> property;
  final PropertyChanged onChanged;

  @override
  Widget build(BuildContext context) {
    return PropertyScaffold(
      tooltipMessage: property.tooltipMessage,
      label: property.name,
      child: DropdownButton<T>(
        isExpanded: true,
        value: property.getValue(),
        onChanged: (value) {
          property.value = value;
          onChanged();
        },
        items: [
          for (final option in property.list)
            DropdownMenuItem<T>(value: option.value, child: Text(option.label)),
        ],
      ),
    );
  }
}
