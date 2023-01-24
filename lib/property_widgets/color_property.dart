import 'package:alkami_core_dependencies/alkami_core_dependencies.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../story.dart';
import 'widgets/property_scaffold.dart';
import 'widgets/property_dialog.dart';

class ColorProperty extends StatefulWidget {
  final Property<Color?>? property;
  final PropertyChanged? onChanged;

  ColorProperty({
    this.property,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ColorPropertyState(property!.getValue());
}

class ColorPropertyState extends State<ColorProperty> {
  Color? pickerColor;
  Color? currentColor;

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  // raise the [showDialog] widget
  Future<dynamic> show() => showDialog(
        context: context,
        builder: (_) => PropertyDialog(
          title: 'Pick a color!',
          content: ColorPicker(
            pickerColor: pickerColor!,
            onColorChanged: changeColor,
            pickerAreaHeightPercent: 0.8,
          ),
          actions: [
            TextButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() => currentColor = pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );

  ColorPropertyState(Color? value) {
    currentColor = value;
    pickerColor = value;
  }

  @override
  Widget build(BuildContext context) {
    return PropertyScaffold(
      label: widget.property!.name,
      child: ElevatedButton(
        child: null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: currentColor,
        ),
        onPressed: () async {
          await show();
          widget.property!.value = currentColor;
          widget.onChanged!(widget.property);
        },
      ),
    );
  }
}
