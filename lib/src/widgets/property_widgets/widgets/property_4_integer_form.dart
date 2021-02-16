import 'package:flutter/material.dart';
import 'property_dialog.dart';

class FourIntegerForm extends StatefulWidget {
  final Function _confirmEdition;
  final int _value1;
  final int _value2;
  final int _value3;
  final int _value4;

  final String _label1;
  final String _label2;
  final String _label3;
  final String _label4;

  FourIntegerForm(
      this._confirmEdition,
      this._value1,
      this._value2,
      this._value3,
      this._value4,
      this._label1,
      this._label2,
      this._label3,
      this._label4);

  @override
  State createState() {
    return _FourIntegerFormState();
  }
}

class _FourIntegerFormState extends State<FourIntegerForm> {
  bool _validValues = true;
  bool _useValueToAll = false;

  final _uniqueValueController = TextEditingController();

  final _firstFieldController = TextEditingController();
  final _secondFieldController = TextEditingController();
  final _thirdFieldController = TextEditingController();
  final _fourthFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _uniqueValueController.text = widget._value1.toString();
    if (_allValueEqual()) {
      _useValueToAll = true;

      _firstFieldController.text = _uniqueValueController.text;
      _secondFieldController.text = _uniqueValueController.text;
      _thirdFieldController.text = _uniqueValueController.text;
      _fourthFieldController.text = _uniqueValueController.text;
    } else {
      _firstFieldController.text = widget._value1.toString();
      _secondFieldController.text = widget._value2.toString();
      _thirdFieldController.text = widget._value3.toString();
      _fourthFieldController.text = widget._value4.toString();
    }
  }

  bool _allValueEqual() {
    List<int> values = [
      widget._value1,
      widget._value2,
      widget._value3,
      widget._value4
    ];
    return values.every((v) => v == values[0]);
  }

  @override
  Widget build(_) {
    return PropertyDialog(
      title: 'Set values:',
      content: Column(
        children: [
          _validValues ? Container() : Text('Invalid values!'),
          Row(children: [
            Text('Same value to all:'),
            Switch(
              value: _useValueToAll,
              onChanged: (bool isOn) => setState(() => _useValueToAll = isOn),
              activeColor: Colors.blue,
              inactiveTrackColor: Colors.grey,
              inactiveThumbColor: Colors.grey,
            ),
          ]),
          _useValueToAll
              ? Container(
                  child: Container(
                      width: 100,
                      child: TextField(controller: _uniqueValueController)),
                )
              : Column(
                  children: [
                    _FieldWithLabel(
                      label: widget._label1,
                      fieldController: _firstFieldController,
                    ),
                    _FieldWithLabel(
                      label: widget._label2,
                      fieldController: _secondFieldController,
                    ),
                    _FieldWithLabel(
                      label: widget._label3,
                      fieldController: _thirdFieldController,
                    ),
                    _FieldWithLabel(
                      label: widget._label4,
                      fieldController: _fourthFieldController,
                    ),
                  ],
                ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Got it'),
          onPressed: () {
            bool validValues = widget._confirmEdition(
                _useValueToAll,
                _uniqueValueController.text,
                _firstFieldController.text,
                _secondFieldController.text,
                _thirdFieldController.text,
                _fourthFieldController.text);

            if (validValues) {
              setState(() {
                _validValues = true;
              });

              Navigator.of(context).pop();
            } else {
              setState(() => _validValues = false);
            }
          },
        ),
      ],
    );
  }
}

class _FieldWithLabel extends StatelessWidget {
  final String label;
  final TextEditingController fieldController;

  _FieldWithLabel({this.label, this.fieldController});

  @override
  Widget build(_) {
    return Row(
      children: [
        Container(width: 105, child: Text('$label:')),
        Container(width: 90, child: TextField(controller: fieldController)),
      ],
    );
  }
}
