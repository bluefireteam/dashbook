import 'package:dashbook/src/widgets/select_device/device_settings.dart';
import 'package:device_frame/device_frame.dart';
import 'package:material_ui/material_ui.dart';

class DeviceDropdown extends StatelessWidget {
  const DeviceDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSettings = DeviceSettings.of(context);

    return DropdownButton<DeviceInfo>(
      isExpanded: true,
      value: deviceSettings.settings.deviceInfo,
      items: [
        for (final device in [...Devices.android.all, ...Devices.ios.all])
          DropdownMenuItem<DeviceInfo>(value: device, child: Text(device.name)),
      ],
      onChanged: deviceSettings.updateDevice,
    );
  }
}
