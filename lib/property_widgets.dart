import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import './story.dart';

typedef PropertyChanged = void Function(Property);

class _PropertyScaffold extends StatelessWidget {
  final String label;
  final Widget child;

  _PropertyScaffold({
    this.label,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(label)),
          Expanded(flex: 6, child: child)
        ],
      ),
    );
  }
}

class TextProperty extends StatefulWidget {
  final Property<String> property;
  final PropertyChanged onChanged;

  TextProperty({
    this.property,
    this.onChanged,
    Key key,
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
    return _PropertyScaffold(
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
    return _PropertyScaffold(
      label: widget.property.name,
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        onChanged: (value) {
          widget.property.value = double.tryParse(value);
          widget.onChanged(widget.property);
        },
        controller: controller,
      ),
    );
  }
}

class BoolProperty extends StatefulWidget {
  final Property<bool> property;
  final PropertyChanged onChanged;

  BoolProperty({
    this.property,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => BoolPropertyState(property.getValue());
}

class BoolPropertyState extends State<BoolProperty> {
  bool _value = false;

  BoolPropertyState(this._value);

  @override
  Widget build(BuildContext context) {
    return _PropertyScaffold(
      label: widget.property.name,
      child: Checkbox(
        value: _value,
        onChanged: (newValue) {
          widget.property.value = newValue;
          widget.onChanged(widget.property);
          setState(() {
            _value = newValue;
          });
        },
      ),
    );
  }
}

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
    return _PropertyScaffold(
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

class ColorProperty extends StatefulWidget {
  final Property<Color> property;
  final PropertyChanged onChanged;

  ColorProperty({
    this.property,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      ColorPropertyState(property.getValue());
}

class ColorPropertyState extends State<ColorProperty> {
  Color pickerColor;
  Color currentColor;

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  // raise the [showDialog] widget
  Future<dynamic> show() => showDialog(
        context: context,
        child: AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: changeColor,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() => currentColor = pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );

  ColorPropertyState(Color value) {
    currentColor = value;
    pickerColor = value;
  }

  @override
  Widget build(BuildContext context) {
    return _PropertyScaffold(
      label: widget.property.name,
      child: RaisedButton(
        elevation: 0,
        color: currentColor,
        onPressed: () async {
          await show();
          widget.property.value = currentColor;
          widget.onChanged(widget.property);
        },
      ),
    );
  }
}
