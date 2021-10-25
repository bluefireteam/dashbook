import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/helpers.dart';
import 'package:dashbook/src/widgets/property_widgets/widgets/property_4_integer_form.dart';
import 'package:dashbook/src/widgets/property_widgets/widgets/property_scaffold.dart';
import 'package:flutter/material.dart';

class EdgeInsetsProperty extends StatefulWidget {
  final Property<EdgeInsets> property;
  final PropertyChanged onChanged;

  const EdgeInsetsProperty({
    required this.property,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      _EdgeInsetsPropertyState(property.getValue());
}

class _EdgeInsetsPropertyState extends State<EdgeInsetsProperty> {
  EdgeInsets _currentEdgeinsets;

  _EdgeInsetsPropertyState(this._currentEdgeinsets);

  EdgeInsets? _parseEdgeInsetValues(
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

        return EdgeInsets.all(value);
      } else {
        final left = double.tryParse(value1);
        final top = double.tryParse(value2);
        final right = double.tryParse(value3);
        final bottom = double.tryParse(value4);

        if (left == null || top == null || right == null || bottom == null) {
          return null;
        }

        return EdgeInsets.fromLTRB(left, top, right, bottom);
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
    final edgetInsetsValue = _parseEdgeInsetValues(
      toAllSides,
      uniqueValue,
      value1,
      value2,
      value3,
      value4,
    );

    if (edgetInsetsValue == null) {
      return false;
    } else {
      _currentEdgeinsets = edgetInsetsValue;
      return true;
    }
  }

  Future<void> show() => showDialog<void>(
        context: context,
        builder: (_) => FourIntegerForm(
          _confirmEdition,
          _currentEdgeinsets.left.toInt(),
          _currentEdgeinsets.top.toInt(),
          _currentEdgeinsets.right.toInt(),
          _currentEdgeinsets.bottom.toInt(),
          'Left',
          'Top',
          'Right',
          'Bottom',
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
              'Left: ${value.left}, '
              'Top: ${value.top}, '
              'Right: ${value.right}, '
              'Bottom: ${value.bottom}',
            )
          else
            Text(
              'L: ${value.left.toInt()}, '
              'T: ${value.top.toInt()}, '
              'R: ${value.right.toInt()}, '
              'B: ${value.bottom.toInt()}',
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
              widget.property.value = _currentEdgeinsets;
              widget.onChanged();
            },
          ),
        ],
      ),
    );
  }
}
