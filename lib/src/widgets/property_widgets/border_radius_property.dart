import 'package:flutter/material.dart';
import './widgets/property_4_integer_form.dart';
import './widgets/property_scaffold.dart';
import '../helpers.dart';
import '../../story.dart';

class BorderRadiusProperty extends StatefulWidget {
  final Property<BorderRadius> property;
  final PropertyChanged onChanged;

  BorderRadiusProperty({
    this.property,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _BorderRadiusPropertyState(property.getValue());
}

class _BorderRadiusPropertyState extends State<BorderRadiusProperty> {
  BorderRadius _currentBorderRadius;

  _BorderRadiusPropertyState(this._currentBorderRadius);

  BorderRadius _parseBorderRadiusValues(bool toAllSides, String uniqueValue,
      String value1, String value2, String value3, String value4) {
    try {
      if (toAllSides) {
        final double value = double.tryParse(uniqueValue);

        if (value == null) {
          return null;
        }

        return BorderRadius.all(Radius.circular(value));
      } else {
        final double topLeft = double.tryParse(value1);
        final double topRight = double.tryParse(value2);
        final double bottomLeft = double.tryParse(value3);
        final double bottomRight = double.tryParse(value4);

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
            bottomRight: Radius.circular(bottomRight));
      }
    } catch (err) {
      return null;
    }
  }

  bool _confirmEdition(bool toAllSides, String uniqueValue, String value1,
      String value2, String value3, String value4) {
    BorderRadius radiusValue = _parseBorderRadiusValues(
        toAllSides, uniqueValue, value1, value2, value3, value4);

    if (radiusValue == null) {
      return false;
    } else {
      _currentBorderRadius = radiusValue;
      return true;
    }
  }

  Future<dynamic> show() => showDialog(
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
          'Bottom right'));

  @override
  Widget build(BuildContext context) {
    final value = widget.property.getValue();

    return PropertyScaffold(
      label: widget.property.name,
      child: Row(
        children: [
          isLargeScreen(context) 
              ? Text(
                  '(Top) left: ${value.topLeft.x} right: ${value.topRight.x} \n(Bottom) left: ${value.bottomLeft.x} right: ${value.bottomRight.x}')
              : Text(
                  'TL: ${value.topLeft.x.toInt()}, TR: ${value.topRight.x.toInt()},\nBL: ${value.bottomLeft.x.toInt()}, BR: ${value.bottomRight.x.toInt()}'),
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
              widget.property.value = _currentBorderRadius;
              widget.onChanged(widget.property);
            },
          ),
        ],
      ),
    );
  }
}
