import 'package:flutter/material.dart';
import '../story.dart';
import 'widgets/property_scaffold.dart';

class BoolProperty extends StatefulWidget {
  final Property<bool?>? property;
  final PropertyChanged? onChanged;

  BoolProperty({
    this.property,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      BoolPropertyState(property!.getValue());
}

class BoolPropertyState extends State<BoolProperty> {
  bool? _value = false;

  BoolPropertyState(this._value);

  @override
  Widget build(BuildContext context) {
    return PropertyScaffold(
      label: widget.property!.name,
      child: Checkbox(
        value: _value,
        onChanged: (newValue) {
          widget.property!.value = newValue;
          widget.onChanged!(widget.property);
          setState(() {
            _value = newValue;
          });
        },
      ),
    );
  }
}
