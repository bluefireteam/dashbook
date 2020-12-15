import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../story.dart';
import 'widgets/property_scaffold.dart';

class IntProperty extends StatefulWidget {
  final Property<int> property;
  final PropertyChanged onChanged;

  IntProperty({
    this.property,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => IntPropertyState(property.getValue());
}

class IntPropertyState extends State<IntProperty> {
  TextEditingController controller = TextEditingController();

  IntPropertyState(int value) {
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
          widget.property.value = int.tryParse(value);
          widget.onChanged(widget.property);
        },
        controller: controller,
      ),
    );
  }
}
