import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/property_widgets/widgets/property_scaffold.dart';
import 'package:flutter/material.dart';

class OptionsPropertyWidget<T> extends StatefulWidget {
  final OptionsProperty<T> property;
  final PropertyChanged onChanged;

  const OptionsPropertyWidget({
    required this.property,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => OptionsPropertyState();
}

class OptionsPropertyState extends State<OptionsPropertyWidget> {
  @override
  Widget build(BuildContext context) {
    return PropertyScaffold(
      label: widget.property.name,
      child: DropdownButton(
        isExpanded: true,
        value: widget.property.getValue(),
        onChanged: (value) {
          widget.property.value = value;
          widget.onChanged();
        },
        items: widget.property.list
            .map(
              (option) => DropdownMenuItem(
                value: option.value,
                child: Text(option.label),
              ),
            )
            .toList(),
      ),
    );
  }
}
