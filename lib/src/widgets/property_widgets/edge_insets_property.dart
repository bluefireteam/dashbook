import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/helpers.dart';
import 'package:dashbook/src/widgets/property_widgets/widgets/four_values_form.dart';
import 'package:material_ui/material_ui.dart';

class EdgeInsetsProperty extends StatelessWidget {
  const EdgeInsetsProperty({
    required this.property,
    required this.onChanged,
    super.key,
  });

  final Property<EdgeInsets> property;
  final PropertyChanged onChanged;

  Future<void> _edit(BuildContext context) async {
    final value = property.getValue();
    final values = await showPopup<List<double>>(
      context: context,
      builder: (_) => FourValuesForm(
        values: [value.left, value.top, value.right, value.bottom],
        labels: const ['Left', 'Top', 'Right', 'Bottom'],
      ),
    );
    if (values == null) {
      return;
    }

    final [left, top, right, bottom] = values;
    property.value = EdgeInsets.fromLTRB(left, top, right, bottom);
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final value = property.getValue();

    return PropertyScaffold(
      tooltipMessage: property.tooltipMessage,
      label: property.name,
      child: Row(
        children: [
          Flexible(
            child: Text(
              isLargeScreen(context)
                  ? 'Left: ${value.left}, '
                        'Top: ${value.top}, '
                        'Right: ${value.right}, '
                        'Bottom: ${value.bottom}'
                  : 'L: ${value.left.toInt()}, '
                        'T: ${value.top.toInt()}, '
                        'R: ${value.right.toInt()}, '
                        'B: ${value.bottom.toInt()}',
            ),
          ),
          const SizedBox(width: 5),
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () => _edit(context),
          ),
        ],
      ),
    );
  }
}
