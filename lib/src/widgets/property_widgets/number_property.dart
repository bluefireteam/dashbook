import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './widgets/property_scaffold.dart';
import '../../story.dart';

class NumberProperty extends StatefulWidget {
  final Property<double> property;
  final PropertyChanged onChanged;

  NumberProperty({
    this.property,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      NumberPropertyState(property.getValue());
}

class NumberPropertyState extends State<NumberProperty> {
  TextEditingController controller = TextEditingController();

  NumberPropertyState(double value) {
    controller.text = value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return PropertyScaffold(
      label: widget.property.name,
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          widget.property.value = double.tryParse(value);
          widget.onChanged(widget.property);
        },
        controller: controller,
      ),
    );
  }
}
