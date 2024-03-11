import 'package:dashbook/src/widgets/select_device/device_settings.dart';
import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';

class DeviceDropdown extends StatelessWidget {
  const DeviceDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = DeviceSettings.of(context).settings;

    return DropdownButton<DeviceInfo>(
      isExpanded: true,
      value: settings.deviceInfo,
      items: [
        ...Devices.android.all,
        ...Devices.ios.all,
      ].map((DeviceInfo device) {
        return DropdownMenuItem<DeviceInfo>(
          value: device,
          child: Text(device.name),
        );
      }).toList(),
      onChanged: DeviceSettings.of(context, listen: false).updateDevice,
    );
  }
}
