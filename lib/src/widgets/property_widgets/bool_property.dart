import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';

class BoolProperty extends StatefulWidget {
  final Property<bool> property;
  final PropertyChanged onChanged;

  const BoolProperty({
    required this.property,
    required this.onChanged,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => BoolPropertyState(property.getValue());
}

class BoolPropertyState extends State<BoolProperty> {
  bool? _value;

  BoolPropertyState(this._value);

  @override
  Widget build(BuildContext context) {
    return PropertyScaffold(
      tooltipMessage: widget.property.tooltipMessage,
      label: widget.property.name,
      child: Checkbox(
        value: _value,
        onChanged: (newValue) {
          widget.property.value = newValue;
          widget.onChanged();
          setState(() {
            _value = newValue;
          });
        },
      ),
    );
  }
}
