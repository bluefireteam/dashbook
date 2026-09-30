import 'package:dashbook/src/widgets/property_widgets/widgets/property_dialog.dart';
import 'package:material_ui/material_ui.dart';

/// A dialog for editing four related values, such as the sides of an
/// [EdgeInsets], which pops with the new values once they are confirmed.
class FourValuesForm extends StatefulWidget {
  const FourValuesForm({required this.values, required this.labels, super.key})
    : assert(
        values.length == 4 && labels.length == 4,
        'Exactly four values and labels are required',
      );

  final List<double> values;
  final List<String> labels;

  @override
  State<FourValuesForm> createState() => _FourValuesFormState();
}

class _FourValuesFormState extends State<FourValuesForm> {
  late final _sameValueController = TextEditingController(
    text: _format(widget.values.first),
  );
  late final _controllers = [
    for (final value in widget.values)
      TextEditingController(text: _format(value)),
  ];
  late bool _useSameValue = widget.values.every(
    (value) => value == widget.values.first,
  );
  bool _validValues = true;

  static String _format(double value) =>
      value.toString().replaceFirst(RegExp(r'\.0$'), '');

  @override
  void dispose() {
    _sameValueController.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _confirm() {
    final values = [
      for (final controller in _controllers)
        double.tryParse(
          _useSameValue ? _sameValueController.text : controller.text,
        ),
    ].nonNulls.toList();

    if (values.length == _controllers.length) {
      Navigator.of(context).pop(values);
    } else {
      setState(() => _validValues = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PropertyDialog(
      title: 'Set values:',
      content: Column(
        children: [
          if (!_validValues)
            Text(
              'Invalid values!',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          Row(
            children: [
              const Text('Same value to all:'),
              Switch(
                value: _useSameValue,
                onChanged: (value) => setState(() => _useSameValue = value),
              ),
            ],
          ),
          if (_useSameValue)
            SizedBox(
              width: 100,
              child: TextField(controller: _sameValueController),
            )
          else
            for (final (index, controller) in _controllers.indexed)
              _FieldWithLabel(
                label: widget.labels[index],
                controller: controller,
              ),
        ],
      ),
      actions: [TextButton(onPressed: _confirm, child: const Text('Got it'))],
    );
  }
}

class _FieldWithLabel extends StatelessWidget {
  const _FieldWithLabel({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 105, child: Text('$label:')),
        SizedBox(width: 90, child: TextField(controller: controller)),
      ],
    );
  }
}
