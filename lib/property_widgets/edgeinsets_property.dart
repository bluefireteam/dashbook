import 'package:flutter/material.dart';
import '../story.dart';
import './widgets/property_scafold.dart';
import 'widgets/property_dialog.dart';

class EdgeinsetsProperty extends StatefulWidget {
  final Property<EdgeInsets> property;
  final PropertyChanged onChanged;

  EdgeinsetsProperty({
    this.property,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EdgeinsetsPropertyState(property.getValue());
}

class _EdgeinsetsPropertyState extends State<EdgeinsetsProperty> {
  EdgeInsets currentEdgeinsets;

  _EdgeinsetsPropertyState(this.currentEdgeinsets);

  void _valueChange(EdgeInsets value) {
    currentEdgeinsets = value;
  }

  Future<dynamic> show() => showDialog(
    context: context,
    child: _DialogForm(valueChange: _valueChange, value: currentEdgeinsets,),
  );

  @override
  Widget build(BuildContext context) {
    return PropertyScaffold(
      label: widget.property.name,
      child: Row(children: [
        Text('Left: ${widget.property.getValue().left}, Top: ${widget.property.getValue().top}, Right: ${widget.property.getValue().right}, Bottom: ${widget.property.getValue().bottom}'),
        SizedBox(width: 5,),
        IconButton(icon: Icon(
          Icons.edit,
          size: 20.0,
        ),
        onPressed: () async {
          await show();
          widget.property.value = currentEdgeinsets;
          widget.onChanged(widget.property);
        },),
      ],),
    );
  }
}

class _DialogForm extends StatefulWidget {
  final Function valueChange;
  final EdgeInsets value;

  _DialogForm({this.value, this.valueChange});

  @override
  State createState() {
    return _DialogFormState();
  }
}

class _DialogFormState extends State<_DialogForm> {
  bool validValues = true;

  TextEditingController leftController = TextEditingController();
  TextEditingController topController = TextEditingController();
  TextEditingController rightController = TextEditingController();
  TextEditingController bottomController = TextEditingController();

  @override
  void initState() {
    super.initState();

    leftController.text = widget.value.left.toString();
    topController.text = widget.value.top.toString();
    rightController.text = widget.value.right.toString();
    bottomController.text = widget.value.bottom.toString();
  }

  @override
  Widget build(_) {
    return PropertyDialog(
      title: 'Set the edge insets:',
      content: Column(
        children: [
          validValues ? Container() : Text('Invalid values!'),
          Row(
            children: [
            Container(width: 70, child: Text('Left:')),
            Container(width: 100, child: TextField(controller: leftController)),
          ],),
          Row(children: [
            Container(width: 70, child: Text('Top:')),
            Container(width: 100, child: TextField(controller: topController)),
          ],),
          Row(children: [
            Container(width: 70, child: Text('Right:')),
            Container(width: 100, child: TextField(controller: rightController)),
          ],),
          Row(children: [
            Container(width: 70, child: Text('Bottom:')),
            Container(width: 100, child: TextField(controller: bottomController)),
          ],),
        ],
      ),
      actions: [
        FlatButton(
          child: const Text('Got it'),
          onPressed: () {
            final parsedEdgeInsets = _parseEdgeInsetValues();

            if (parsedEdgeInsets == null) {
              setState(() => validValues = false);
            } else {
              setState(() {
                validValues = true;
                widget.valueChange(parsedEdgeInsets);
              });
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  EdgeInsets _parseEdgeInsetValues () {
    try {
      final double left = double.tryParse(leftController.text);
      final double top = double.tryParse(topController.text);
      final double right = double.tryParse(rightController.text);
      final double bottom = double.tryParse(bottomController.text);

      if (left == null || top == null || right == null || bottom == null) {
        return null;
      }
      
      return EdgeInsets.fromLTRB(left, top, right, bottom);
    } catch(err) {
      return null;
    }
  }
}