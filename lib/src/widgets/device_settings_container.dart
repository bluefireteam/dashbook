import 'package:dashbook/src/widgets/dashbook_icon.dart';
import 'package:dashbook/src/widgets/helpers.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:dashbook/src/widgets/select_device/custom_device.dart';
import 'package:dashbook/src/widgets/select_device/device_settings.dart';
import 'package:dashbook/src/widgets/select_device/select_device.dart';
import 'package:dashbook/src/widgets/side_bar_panel.dart';
import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';

class DeviceSettingsContainer extends StatefulWidget {
  final VoidCallback onCancel;

  const DeviceSettingsContainer({
    Key? key,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<DeviceSettingsContainer> createState() =>
      _DeviceSettingsContainerState();
}

class _DeviceSettingsContainerState extends State<DeviceSettingsContainer> {
  final _formKey = GlobalKey<FormState>();
  bool _isCustom = false;

  void _setIsCustom(bool isCustom) {
    setState(() {
      _isCustom = isCustom;
      DeviceSettings.of(context, listen: false).updateDevice(
        isCustom ? Devices.android.largeTablet : null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SideBarPanel(
      title: 'Properties',
      onCloseKey: kDevicePreviewCloseIcon,
      width: sideBarSizeProperties(context),
      onCancel: widget.onCancel,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _DeviceToggles(),
            CheckboxListTile(
              value: _isCustom,
              key: kCustomDeviceToggle,
              title: const Text('Custom device'),
              contentPadding: EdgeInsets.zero,
              onChanged: (value) => _setIsCustom(value!),
            ),
            if (_isCustom)
              CustomDevice(
                formKey: _formKey,
                changeToList: () {
                  _setIsCustom(false);
                },
              )
            else
              const SelectDevice(),
          ],
        ),
      ),
    );
  }
}

class _DeviceToggles extends StatelessWidget {
  const _DeviceToggles();

  @override
  Widget build(BuildContext context) {
    final deviceSettings = DeviceSettings.of(context);

    return Row(
      children: [
        DashbookIcon(
          key: kRotateIcon,
          tooltip: 'Orientation',
          icon: Icons.screen_rotation_outlined,
          onClick: deviceSettings.settings.deviceInfo != null
              ? deviceSettings.rotate
              : null,
        ),
        DashbookIcon(
          key: kHideFrameIcon,
          tooltip: 'Device frame',
          icon: Icons.mobile_off_outlined,
          onClick: deviceSettings.settings.deviceInfo != null
              ? deviceSettings.toggleDeviceFrame
              : null,
        ),
        const Spacer(),
        TextButton(
          onPressed: deviceSettings.reset,
          child: const Text('Reset'),
        ),
      ],
    );
  }
}
