import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './story.dart';

typedef PropertyChanged = void Function(Property);

class TextProperty extends StatefulWidget {

  final Property<String> property;
  final PropertyChanged onChanged;

  TextProperty({ this.property, this.onChanged });

  @override
  State<StatefulWidget> createState() => TextPropertyState(property.getValue());
}

class TextPropertyState extends State<TextProperty> {

  TextEditingController controller = TextEditingController();

  TextPropertyState(String value) {
    controller.text = value;
  }

  @override
  Widget build(BuildContext context) {
    return
        Row(
            mainAxisSize: MainAxisSize.min,
            children:[
              SizedBox(width: 25),
              Text(widget.property.name),
              SizedBox(width: 25),
              Expanded(child:
                  TextField(
                      onChanged: (value) {
                        widget.property.value = value;
                        widget.onChanged(widget.property);
                      },
                      controller: controller
                  )
              ),
              SizedBox(width: 25),
            ]
        );
  }
}

class NumberProperty extends StatefulWidget {

  final Property<double> property;
  final PropertyChanged onChanged;

  NumberProperty({ this.property, this.onChanged });

  @override
  State<StatefulWidget> createState() => NumberPropertyState(property.getValue());
}

class NumberPropertyState extends State<NumberProperty> {

  TextEditingController controller = TextEditingController();

  NumberPropertyState(double value) {
    controller.text = value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return
        Row(
            mainAxisSize: MainAxisSize.min,
            children:[
              SizedBox(width: 25),
              Text(widget.property.name),
              SizedBox(width: 25),
              Expanded(child:
                  TextField(
                      keyboardType:TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        widget.property.value = double.tryParse(value);
                        widget.onChanged(widget.property);
                      },
                      controller: controller
                  )
              ),
              SizedBox(width: 25),
            ]
        );
  }
}

