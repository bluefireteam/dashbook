import 'package:dashbook/src/widgets/select_device/custom_device.dart';
import 'package:dashbook/src/widgets/select_device/device_dialog_buttons.dart';
import 'package:dashbook/src/widgets/select_device/select_device.dart';
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
  bool _isCustom = false;

  @override
  void initState() {
    super.initState();

    _selectedDevice = widget.currentSelection;
  }

  void _selectDevice(BuildContext context, [DeviceInfo? select]) {
    Navigator.of(context).pop(select);
  }

  set isCustom(bool value) => setState(() => _isCustom = value);
  bool get isCustom => _isCustom;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isCustom)
              CustomDevice(
                changeToList: () => isCustom = false,
              )
            else
              SelectDevice(
                selectedDevice: _selectedDevice,
                onSelect: (device) => setState(() => _selectedDevice = device),
                changeToCustom: () => isCustom = true,
              ),
            const SizedBox(height: 15),
            DeviceDialogButtons(
              onCancel: () => _selectDevice(context, widget.currentSelection),
              onSelect: () => _selectDevice(context, _selectedDevice),
              onClear: () => _selectDevice(context),
            ),
          ],
        ),
      ),
    );
  }
}
