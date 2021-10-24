import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';

class DeviceDialog extends StatefulWidget {
  final DeviceInfo? currentSelection;

  const DeviceDialog({
    Key? key,
    this.currentSelection,
  }) : super(key: key);

  @override
  State<DeviceDialog> createState() => _DeviceDialogState();
}

class _DeviceDialogState extends State<DeviceDialog> {
  DeviceInfo? _selectedDevice;

  @override
  void initState() {
    super.initState();

    _selectedDevice = widget.currentSelection;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Select a device frame'),
            SizedBox(
              height: 15,
            ),
            DropdownButton<DeviceInfo>(
              value: _selectedDevice,
              items: [
                ...Devices.android.all,
                ...Devices.ios.all,
              ].map((DeviceInfo device) {
                return DropdownMenuItem(
                  value: device,
                  child: Text(device.name),
                );
              }).toList(),
              onChanged: (device) => setState(() => _selectedDevice = device),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(_selectedDevice),
                  child: Text('Select'),
                ),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pop(widget.currentSelection),
                  child: Text('Cancel'),
                ),
                SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Clear'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
