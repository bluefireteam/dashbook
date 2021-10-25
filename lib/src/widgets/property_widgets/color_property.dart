import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/property_widgets/widgets/property_dialog.dart';
import 'package:dashbook/src/widgets/property_widgets/widgets/property_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorProperty extends StatefulWidget {
  final Property<Color> property;
  final PropertyChanged onChanged;

  const ColorProperty({
    required this.property,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      ColorPropertyState(property.getValue());
}

class ColorPropertyState extends State<ColorProperty> {
  late Color pickerColor;
  late Color currentColor;

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  // raise the [showDialog] widget
  Future<void> show() => showDialog<void>(
        context: context,
        builder: (_) => PropertyDialog(
          title: 'Pick a color!',
          content: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
            pickerAreaHeightPercent: 0.8,
          ),
          actions: [
            ElevatedButton(
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
    return PropertyScaffold(
      label: widget.property.name,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: currentColor,
        ),
        onPressed: () async {
          await show();
          widget.property.value = currentColor;
          widget.onChanged();
        },
        child: Container(),
      ),
    );
  }
}
