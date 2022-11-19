import 'package:dashbook/src/widgets/property_widgets/widgets/title_with_tooltip.dart';
import 'package:dashbook/src/widgets/select_device/device_settings.dart';
import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';

class SelectDevice extends StatelessWidget {
  const SelectDevice({
    required this.changeToCustom,
    Key? key,
  }) : super(key: key);
  final VoidCallback changeToCustom;

  @override
  Widget build(BuildContext context) {
    final settings = DeviceSettings.of(context).settings;
    return Column(
      children: [
        DevicePropertyScaffold(
          label: 'Select a device frame:',
          child: DropdownButton<DeviceInfo>(
            isExpanded: true,
            value: settings.deviceInfo,
            items: [
              ...Devices.android.all,
              ...Devices.ios.all,
            ].map((DeviceInfo device) {
              return DropdownMenuItem(
                value: device,
                child: Text(device.name),
              );
            }).toList(),
            onChanged: DeviceSettings.of(context).updateDevice,
          ),
        ),
        const SizedBox(height: 12),
        DevicePropertyScaffold(
          label: 'Text scale factor:',
          child: Slider(
            value: settings.textScaleFactor,
            divisions: 3,
            min: 0.85,
            max: 1.3,
            label: settings.textScaleFactor.toString(),
            onChanged: DeviceSettings.of(context).updateTextScaleFactor,
          ),
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

class DevicePropertyScaffold extends StatelessWidget {
  final String label;
  final Widget child;
  final String? tooltipMessage;

  const DevicePropertyScaffold({
    Key? key,
    required this.label,
    required this.child,
    this.tooltipMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: tooltipMessage != null
                ? TitleWithTooltip(
                    label: label,
                    tooltipMessage: tooltipMessage!,
                  )
                : Text(label),
          ),
          Expanded(flex: 6, child: child)
        ],
      ),
    );
  }
}
