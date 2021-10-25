import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/helpers.dart';
import 'package:dashbook/src/widgets/property_widgets/widgets/property_4_integer_form.dart';
import 'package:dashbook/src/widgets/property_widgets/widgets/property_scaffold.dart';
import 'package:flutter/material.dart';

class BorderRadiusProperty extends StatefulWidget {
  final Property<BorderRadius> property;
  final PropertyChanged onChanged;

  const BorderRadiusProperty({
    required this.property,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _BorderRadiusPropertyState(property.getValue());
}

class _BorderRadiusPropertyState extends State<BorderRadiusProperty> {
  BorderRadius _currentBorderRadius;

  _BorderRadiusPropertyState(this._currentBorderRadius);

  BorderRadius? _parseBorderRadiusValues(
    bool toAllSides,
    String uniqueValue,
    String value1,
    String value2,
    String value3,
    String value4,
  ) {
    try {
      if (toAllSides) {
        final value = double.tryParse(uniqueValue);

        if (value == null) {
          return null;
        }

        return BorderRadius.all(Radius.circular(value));
      } else {
        final topLeft = double.tryParse(value1);
        final topRight = double.tryParse(value2);
        final bottomLeft = double.tryParse(value3);
        final bottomRight = double.tryParse(value4);

        if (topLeft == null ||
            topRight == null ||
            bottomLeft == null ||
            bottomRight == null) {
          return null;
        }

        return BorderRadius.only(
          topLeft: Radius.circular(topLeft),
          topRight: Radius.circular(topRight),
          bottomLeft: Radius.circular(bottomLeft),
          bottomRight: Radius.circular(bottomRight),
        );
      }
    } catch (err) {
      return null;
    }
  }

  bool _confirmEdition(
    bool toAllSides,
    String uniqueValue,
    String value1,
    String value2,
    String value3,
    String value4,
  ) {
    final radiusValue = _parseBorderRadiusValues(
      toAllSides,
      uniqueValue,
      value1,
      value2,
      value3,
      value4,
    );

    if (radiusValue == null) {
      return false;
    } else {
      _currentBorderRadius = radiusValue;
      return true;
    }
  }

  Future<void> show() => showDialog<void>(
        context: context,
        builder: (_) => FourIntegerForm(
          _confirmEdition,
          _currentBorderRadius.topLeft.x.toInt(),
          _currentBorderRadius.topRight.x.toInt(),
          _currentBorderRadius.bottomLeft.x.toInt(),
          _currentBorderRadius.bottomRight.x.toInt(),
          'Top left',
          'Top right',
          'Bottom left',
          'Bottom right',
        ),
      );

  @override
  Widget build(BuildContext context) {
    final value = widget.property.getValue();

    return PropertyScaffold(
      label: widget.property.name,
      child: Row(
        children: [
          if (isLargeScreen(context))
            Text(
              '(Top) left: ${value.topLeft.x} '
              'right: ${value.topRight.x} \n'
              '(Bottom) left: ${value.bottomLeft.x} '
              'right: ${value.bottomRight.x}',
            )
          else
            Text(
              'TL: ${value.topLeft.x.toInt()}, '
              'TR: ${value.topRight.x.toInt()},\n'
              'BL: ${value.bottomLeft.x.toInt()}, '
              'BR: ${value.bottomRight.x.toInt()}',
            ),
          const SizedBox(
            width: 5,
          ),
          IconButton(
            icon: const Icon(
              Icons.edit,
              size: 20,
            ),
            onPressed: () async {
              await show();
              widget.property.value = _currentBorderRadius;
              widget.onChanged();
            },
          ),
        ],
      ),
    );
  }
}
