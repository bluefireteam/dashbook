import 'package:flutter/material.dart';
import './widgets/property_scaffold.dart';
import '../../story.dart';

class TextProperty extends StatefulWidget {
  final Property<String> property;
  final PropertyChanged onChanged;

  TextProperty({
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
          widget.onChanged(widget.property);
        },
        controller: controller,
      ),
    );
  }
}
