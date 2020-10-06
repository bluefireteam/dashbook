import 'package:flutter/material.dart';
import '../story.dart';
import 'widgets/property_scaffold.dart';

class ListPropertyWidget<T> extends StatefulWidget {
  final ListProperty<T> property;
  final PropertyChanged onChanged;

  ListPropertyWidget({
    this.property,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ListPropertyState();
}

class ListPropertyState extends State<ListPropertyWidget> {
  @override
  Widget build(BuildContext context) {
    return PropertyScaffold(
      label: widget.property.name,
      child: DropdownButton(
        value: widget.property.getValue(),
        onChanged: (value) {
          widget.property.value = value;
          widget.onChanged(widget.property);
        },
        items: widget.property.list
            .map(
              (value) => DropdownMenuItem(
                value: value,
                child: Text(value.toString()),
              ),
            )
            .toList(),
      ),
    );
  }
}
