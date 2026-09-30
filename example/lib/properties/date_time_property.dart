import 'package:dashbook/dashbook.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class DateTimeProperty extends Property<DateTime> {
  new(super.name, super.defaultValue);

  @override
  Widget createPropertyEditor({required PropertyChanged onChanged, Key? key}) {
    return DateTimePropertyView(property: this, onChanged: onChanged, key: key);
  }
}

class DateTimePropertyView extends StatelessWidget {
  const new({required this.property, required this.onChanged, super.key});

  final Property<DateTime> property;
  final PropertyChanged onChanged;

  static final DateFormat dateFormat = DateFormat.yMMMMEEEEd();

  Future<void> _pickDate(BuildContext context) async {
    final selectedDate = property.getValue();
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: selectedDate.subtract(const Duration(days: 365 * 5)),
      lastDate: selectedDate.add(const Duration(days: 365 * 5)),
    );
    if (date == null) {
      return;
    }

    property.value = date;
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return PropertyScaffold(
      tooltipMessage: property.tooltipMessage,
      label: property.name,
      child: OutlinedButton(
        onPressed: () => _pickDate(context),
        child: Text(dateFormat.format(property.getValue())),
      ),
    );
  }
}
