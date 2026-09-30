import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/helpers.dart';
import 'package:dashbook/src/widgets/property_widgets/widgets/four_values_form.dart';
import 'package:material_ui/material_ui.dart';

class BorderRadiusProperty extends StatelessWidget {
  const BorderRadiusProperty({
    required this.property,
    required this.onChanged,
    super.key,
  });

  final Property<BorderRadius> property;
  final PropertyChanged onChanged;

  Future<void> _edit(BuildContext context) async {
    final value = property.getValue();
    final values = await showPopup<List<double>>(
      context: context,
      builder: (_) => FourValuesForm(
        values: [
          value.topLeft.x,
          value.topRight.x,
          value.bottomLeft.x,
          value.bottomRight.x,
        ],
        labels: const ['Top left', 'Top right', 'Bottom left', 'Bottom right'],
      ),
    );
    if (values == null) {
      return;
    }

    final [topLeft, topRight, bottomLeft, bottomRight] = values;
    property.value = BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
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
                  ? '(Top) left: ${value.topLeft.x} '
                        'right: ${value.topRight.x} \n'
                        '(Bottom) left: ${value.bottomLeft.x} '
                        'right: ${value.bottomRight.x}'
                  : 'TL: ${value.topLeft.x.toInt()}, '
                        'TR: ${value.topRight.x.toInt()},\n'
                        'BL: ${value.bottomLeft.x.toInt()}, '
                        'BR: ${value.bottomRight.x.toInt()}',
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
