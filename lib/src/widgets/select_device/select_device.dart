import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';

class SelectDevice extends StatelessWidget {
  const SelectDevice({
    required this.selectedDevice,
    required this.onSelect,
    required this.changeToCustom,
    Key? key,
  }) : super(key: key);
  final DeviceInfo? selectedDevice;
  final Function(DeviceInfo?) onSelect;
  final VoidCallback changeToCustom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Select a device frame'),
        const SizedBox(
          height: 15,
        ),
        DropdownButton<DeviceInfo>(
          value: selectedDevice,
          items: [
            ...Devices.android.all,
            ...Devices.ios.all,
          ].map((DeviceInfo device) {
            return DropdownMenuItem(
              value: device,
              child: Text(device.name),
            );
          }).toList(),
          onChanged: onSelect,
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: changeToCustom,
          child: const Text('Custom Device'),
        ),
      ],
    );
  }
}
