import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../story.dart';
import 'widgets/property_scaffold.dart';
import 'widgets/property_dialog.dart';

class EdgeInsetsProperty extends StatefulWidget {
  final Property<EdgeInsets> property;
  final PropertyChanged onChanged;

  EdgeInsetsProperty({
    this.property,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _EdgeInsetsPropertyState(property.getValue());
}

class _EdgeInsetsPropertyState extends State<EdgeInsetsProperty> {
  EdgeInsets _currentEdgeinsets;

  _EdgeInsetsPropertyState(this._currentEdgeinsets);

  void _valueChange(EdgeInsets value) {
    _currentEdgeinsets = value;
  }

  Future<dynamic> show() => showDialog(
        context: context,
        child: _DialogForm(
          _currentEdgeinsets,
          _valueChange,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final value = widget.property.getValue();

    return PropertyScaffold(
      label: widget.property.name,
      child: Row(
        children: [
          kIsWeb
          ? Text('Left: ${value.left}, Top: ${value.top}, Right: ${value.right}, Bottom: ${value.bottom}')
              : Text('L: ${value.left.toInt()}, T: ${value.top.toInt()}, R: ${value.right.toInt()}, B: ${value.bottom.toInt()}'),
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

class _DialogForm extends StatefulWidget {
  final Function _valueChange;
  final EdgeInsets _value;

  _DialogForm(this._value, this._valueChange);

  @override
  State createState() {
    return _DialogFormState();
  }
}

class _DialogFormState extends State<_DialogForm> {
  bool _validValues = true;
  bool _useValueToAllSides = false;

  final _uniqueValueController = TextEditingController();

  final _leftController = TextEditingController();
  final _topController = TextEditingController();
  final _rightController = TextEditingController();
  final _bottomController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _uniqueValueController.text = widget._value.left.toInt().toString();
    if (_allValueEqual()) {
      _useValueToAllSides = true;

      _leftController.text = _uniqueValueController.text;
      _topController.text = _uniqueValueController.text;
      _rightController.text = _uniqueValueController.text;
      _bottomController.text = _uniqueValueController.text;
    } else {
      final value = widget._value;

      _leftController.text = value.left.toInt().toString();
      _topController.text = value.top.toInt().toString();
      _rightController.text = value.right.toInt().toString();
      _bottomController.text = value.bottom.toInt().toString();
    }
  }

  bool _allValueEqual() {
    final value = widget._value;

    List<double> values = [value.left, value.top, value.right, value.bottom];
    return values.every((v) => v == values[0]);
  }

  @override
  Widget build(_) {
    return PropertyDialog(
      title: 'Set the edge insets:',
      content: Column(
        children: [
          _validValues ? Container() : Text('Invalid values!'),
          Row(children: [
            Text('Same value to all:'),
            Switch(
              value: _useValueToAllSides,
              onChanged: (bool isOn) =>
                  setState(() => _useValueToAllSides = isOn),
              activeColor: Colors.blue,
              inactiveTrackColor: Colors.grey,
              inactiveThumbColor: Colors.grey,
            ),
          ]),
          _useValueToAllSides
              ? Container(
                  child: Container(
                      width: 100,
                      child: TextField(controller: _uniqueValueController)),
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Container(width: 70, child: Text('Left:')),
                        Container(
                            width: 100,
                            child: TextField(controller: _leftController)),
                      ],
                    ),
                    Row(
                      children: [
                        Container(width: 70, child: Text('Top:')),
                        Container(
                            width: 100,
                            child: TextField(controller: _topController)),
                      ],
                    ),
                    Row(
                      children: [
                        Container(width: 70, child: Text('Right:')),
                        Container(
                            width: 100,
                            child: TextField(controller: _rightController)),
                      ],
                    ),
                    Row(
                      children: [
                        Container(width: 70, child: Text('Bottom:')),
                        Container(
                            width: 100,
                            child: TextField(controller: _bottomController)),
                      ],
                    ),
                  ],
                ),
        ],
      ),
      actions: [
        FlatButton(
          child: const Text('Got it'),
          onPressed: () {
            final parsedEdgeInsets = _parseEdgeInsetValues();

            if (parsedEdgeInsets == null) {
              setState(() => _validValues = false);
            } else {
              setState(() {
                _validValues = true;
                widget._valueChange(parsedEdgeInsets);
              });
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  EdgeInsets _parseEdgeInsetValues() {
    try {
      if (_useValueToAllSides) {
        final double value = double.tryParse(_uniqueValueController.text);

        if (value == null) {
          return null;
        }

        return EdgeInsets.all(value);
      } else {
        final double left = double.tryParse(_leftController.text);
        final double top = double.tryParse(_topController.text);
        final double right = double.tryParse(_rightController.text);
        final double bottom = double.tryParse(_bottomController.text);

        if (left == null || top == null || right == null || bottom == null) {
          return null;
        }

        return EdgeInsets.fromLTRB(left, top, right, bottom);
      }
    } catch (err) {
      return null;
    }
  }
}
