import 'package:dashbook/dashbook.dart';
import 'package:material_ui/material_ui.dart';

class ListPropertyWidget<T> extends StatelessWidget {
  const new({required this.property, required this.onChanged, super.key});

  final ListProperty<T> property;
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
          for (final value in property.list)
            DropdownMenuItem<T>(value: value, child: Text(value.toString())),
        ],
      ),
    );
  }
}
