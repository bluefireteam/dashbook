import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';

class ListPropertyWidget<T> extends StatefulWidget {
  final ListProperty<T> property;
  final PropertyChanged onChanged;

  const ListPropertyWidget({
    required this.property,
    required this.onChanged,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => ListPropertyState<T>();
}

class ListPropertyState<T> extends State<ListPropertyWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return PropertyScaffold(
      tooltipMessage: widget.property.tooltipMessage,
      label: widget.property.name,
      child: DropdownButton<T>(
        isExpanded: true,
        value: widget.property.getValue(),
        onChanged: (value) {
          widget.property.value = value;
          widget.onChanged();
        },
        items: widget.property.list
            .map(
              (value) => DropdownMenuItem<T>(
                value: value,
                child: Text(value.toString()),
              ),
            )
            .toList(),
      ),
    );
  }
}
