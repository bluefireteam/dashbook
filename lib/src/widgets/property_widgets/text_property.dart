import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/property_widgets/widgets/property_scaffold.dart';
import 'package:flutter/material.dart';

class TextProperty extends StatefulWidget {
  final Property<String> property;
  final PropertyChanged onChanged;

  const TextProperty({
    required this.property,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TextPropertyState(property.getValue());
}

class TextPropertyState extends State<TextProperty> {
  TextEditingController controller = TextEditingController();

  TextPropertyState(String value) {
    controller.text = value;
  }

  @override
  Widget build(BuildContext context) {
    return PropertyScaffold(
      label: widget.property.name,
      child: TextField(
        onChanged: (value) {
          widget.property.value = value;
          widget.onChanged();
        },
        controller: controller,
      ),
    );
  }
}
