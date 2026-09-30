import 'package:dashbook/dashbook.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

class NumberProperty extends StatelessWidget {
  const new({required this.property, required this.onChanged, super.key});

  final Property<double> property;
  final PropertyChanged onChanged;

  @override
  Widget build(BuildContext context) {
    return PropertyScaffold(
      tooltipMessage: property.tooltipMessage,
      label: property.name,
      child: TextFormField(
        initialValue: property.getValue().toString(),
        keyboardType: const TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
        ],
        onChanged: (value) {
          property.value = double.tryParse(value);
          onChanged();
        },
      ),
    );
  }
}
