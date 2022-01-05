import 'package:flutter/material.dart';

class DeviceDialogButtons extends StatelessWidget {
  const DeviceDialogButtons({
    Key? key,
    required this.onSelect,
    required this.onClear,
    required this.onCancel,
  }) : super(key: key);
  final VoidCallback onSelect;
  final VoidCallback onClear;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onSelect,
          child: const Text('Select'),
        ),
        const SizedBox(
          width: 15,
        ),
        ElevatedButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
        const SizedBox(
          width: 15,
        ),
        ElevatedButton(
          onPressed: onClear,
          child: const Text('Clear'),
        ),
      ],
    );
  }
}
