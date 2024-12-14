import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';

class SliderProperty extends StatefulWidget {
  final Property<double> property;
  final PropertyChanged onChanged;

  const SliderProperty({
    required this.property,
    required this.onChanged,
    super.key,
  });

  @override
  State<StatefulWidget> createState() =>
      SliderPropertyState(property.getValue());
}

class SliderPropertyState extends State<SliderProperty> {
  double value;
  SliderPropertyState(this.value);

  @override
  Widget build(BuildContext context) {
    return PropertyScaffold(
      tooltipMessage: widget.property.tooltipMessage,
      label: widget.property.name,
      child: Slider(
        value: value,
        onChanged: (newValue) {
          value = newValue;
          widget.property.value = newValue;
          widget.onChanged();
        },
      ),
    );
  }
}
