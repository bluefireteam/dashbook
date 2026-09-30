import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/helpers.dart';
import 'package:dashbook/src/widgets/property_widgets/widgets/property_dialog.dart';
// Needed until flutter_colorpicker has migrated to material_ui.
import 'package:flutter/material.dart' as legacy;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:material_ui/material_ui.dart';

class ColorProperty extends StatelessWidget {
  const new({required this.property, required this.onChanged, super.key});

  final Property<Color> property;
  final PropertyChanged onChanged;

  Future<void> _pickColor(BuildContext context) async {
    final color = await showPopup<Color>(
      context: context,
      builder: (_) => _ColorPickerDialog(initialColor: property.getValue()),
    );
    if (color == null) {
      return;
    }

    property.value = color;
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return PropertyScaffold(
      tooltipMessage: property.tooltipMessage,
      label: property.name,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: property.getValue()),
        onPressed: () => _pickColor(context),
        child: const SizedBox.shrink(),
      ),
    );
  }
}

class _ColorPickerDialog extends StatefulWidget {
  const new({required this.initialColor});

  final Color initialColor;

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _color = widget.initialColor;

  @override
  Widget build(BuildContext context) {
    return PropertyDialog(
      title: 'Pick a color!',
      content: legacy.Material(
        type: legacy.MaterialType.transparency,
        child: ColorPicker(
          pickerColor: _color,
          onColorChanged: (color) => setState(() => _color = color),
          pickerAreaHeightPercent: 0.8,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_color),
          child: const Text('Got it'),
        ),
      ],
    );
  }
}
