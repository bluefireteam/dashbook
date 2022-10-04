import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeProperty extends Property<DateTime> {
  DateTimeProperty(
    super.name,
    super.defaultValue,
  );

  @override
  Widget createPropertyEditor({
    required PropertyChanged onChanged,
    Key? key,
  }) {
    return DateTimePropertyView(
      property: this,
      onChanged: onChanged,
      key: key,
    );
  }
}

class DateTimePropertyView extends StatelessWidget {
  final Property<DateTime> property;
  final PropertyChanged onChanged;

  const DateTimePropertyView({
    required this.property,
    required this.onChanged,
    super.key,
  });

  static DateFormat dateFormat = DateFormat.yMMMMEEEEd();

  @override
  Widget build(BuildContext context) {
    final selectedDate = property.getValue();

    return PropertyScaffold(
      tooltipMessage: property.tooltipMessage,
      label: property.name,
      child: OutlinedButton(
        onPressed: () async {
          property.value = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime.now(),
            lastDate: selectedDate.add(const Duration(days: 365 * 5)),
          );
          onChanged();
        },
        child: Text(dateFormat.format(property.getValue())),
      ),
    );
  }
}
