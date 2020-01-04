import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './story.dart';

typedef PropertyChanged = void Function(Property);

class _PropertyScaffold extends StatelessWidget {
  final String label;
  final Widget child;

  _PropertyScaffold({this.label, this.child});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
        child: Row(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(width: 25),
      Text(label),
      SizedBox(width: 25),
      Expanded(child: child)
    ]));
  }
}

class TextProperty extends StatefulWidget {
  final Property<String> property;
  final PropertyChanged onChanged;

  TextProperty({this.property, this.onChanged});

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
    return _PropertyScaffold(
        label: widget.property.name,
        child: TextField(
            onChanged: (value) {
              widget.property.value = value;
              widget.onChanged(widget.property);
            },
            controller: controller));
  }
}

class NumberProperty extends StatefulWidget {
  final Property<double> property;
  final PropertyChanged onChanged;

  NumberProperty({this.property, this.onChanged});

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
    return _PropertyScaffold(
        label: widget.property.name,
        child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            onChanged: (value) {
              widget.property.value = double.tryParse(value);
              widget.onChanged(widget.property);
            },
            controller: controller));
  }
}

class ListPropertyWidget<T> extends StatefulWidget {
  final ListProperty<T> property;
  final PropertyChanged onChanged;

  ListPropertyWidget({this.property, this.onChanged});

  @override
  State<StatefulWidget> createState() => ListPropertyState();
}

class ListPropertyState extends State<ListPropertyWidget> {
  @override
  Widget build(BuildContext context) {
    return _PropertyScaffold(
        label: widget.property.name,
        child: DropdownButton(
            value: widget.property.getValue(),
            onChanged: (value) {
              widget.property.value = value;
              widget.onChanged(widget.property);
            },
            items: widget.property.list
                .map((value) => DropdownMenuItem(
                      value: value,
                      child: Text(value.toString()),
                    ))
                .toList()));
  }
}
