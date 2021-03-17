import 'package:flutter/material.dart';
import './widgets/property_scaffold.dart';
import './widgets/property_4_integer_form.dart';
import '../helpers.dart';
import '../../story.dart';

class EdgeInsetsProperty extends StatefulWidget {
  final Property<EdgeInsets> property;
  final PropertyChanged onChanged;

  EdgeInsetsProperty({
    required this.property,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _EdgeInsetsPropertyState(property.getValue());
}

class _EdgeInsetsPropertyState extends State<EdgeInsetsProperty> {
  EdgeInsets _currentEdgeinsets;

  _EdgeInsetsPropertyState(this._currentEdgeinsets);

  EdgeInsets? _parseEdgeInsetValues(bool toAllSides, String uniqueValue,
      String value1, String value2, String value3, String value4) {
    try {
      if (toAllSides) {
        final double? value = double.tryParse(uniqueValue);

        if (value == null) {
          return null;
        }

        return EdgeInsets.all(value);
      } else {
        final double? left = double.tryParse(value1);
        final double? top = double.tryParse(value2);
        final double? right = double.tryParse(value3);
        final double? bottom = double.tryParse(value4);

        if (left == null || top == null || right == null || bottom == null) {
          return null;
        }

        return EdgeInsets.fromLTRB(left, top, right, bottom);
      }
    } catch (err) {
      return null;
    }
  }

  bool _confirmEdition(bool toAllSides, String uniqueValue, String value1,
      String value2, String value3, String value4) {
    EdgeInsets? edgetInsetsValue = _parseEdgeInsetValues(
        toAllSides, uniqueValue, value1, value2, value3, value4);

    if (edgetInsetsValue == null) {
      return false;
    } else {
      _currentEdgeinsets = edgetInsetsValue;
      return true;
    }
  }

  Future<dynamic> show() => showDialog(
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
          'Bottom'));

  @override
  Widget build(BuildContext context) {
    final value = widget.property.getValue();

    return PropertyScaffold(
      label: widget.property.name,
      child: Row(
        children: [
          isLargeScreen(context)
              ? Text(
                  'Left: ${value.left}, Top: ${value.top}, Right: ${value.right}, Bottom: ${value.bottom}')
              : Text(
                  'L: ${value.left.toInt()}, T: ${value.top.toInt()}, R: ${value.right.toInt()}, B: ${value.bottom.toInt()}'),
          SizedBox(
            width: 5,
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 20.0,
            ),
            onPressed: () async {
              await show();
              widget.property.value = _currentEdgeinsets;
              widget.onChanged(widget.property);
            },
          ),
        ],
      ),
    );
  }
}
