import 'package:dashbook/src/widgets/dashbook_icon.dart';
import 'package:dashbook/src/widgets/helpers.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:dashbook/src/widgets/select_device/custom_device.dart';
import 'package:dashbook/src/widgets/select_device/device_settings.dart';
import 'package:dashbook/src/widgets/select_device/select_device.dart';
import 'package:dashbook/src/widgets/side_bar_panel.dart';
import 'package:material_ui/material_ui.dart';

class DeviceSettingsContainer extends StatelessWidget {
  const new({required this.onCancel, super.key});

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final deviceSettings = DeviceSettings.of(context);
    final isCustom = deviceSettings.settings.isCustomDevice;

    return SideBarPanel(
      title: 'Device settings',
      onCloseKey: kDevicePreviewCloseIcon,
      width: sideBarSizeProperties(context),
      onCancel: onCancel,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _DeviceToggles(),
            CheckboxListTile(
              value: isCustom,
              key: kCustomDeviceToggle,
              title: const Text('Custom device'),
              contentPadding: EdgeInsets.zero,
              onChanged: (_) => isCustom
                  ? deviceSettings.updateDevice(null)
                  : deviceSettings.useCustomDevice(),
            ),
            if (isCustom) const CustomDevice() else const SelectDevice(),
          ],
        ),
      ),
    );
  }
}

class _DeviceToggles extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final deviceSettings = DeviceSettings.of(context);
    final hasDevice = deviceSettings.settings.deviceInfo != null;

    return Row(
      children: [
        DashbookIcon(
          key: kRotateIcon,
          tooltip: 'Orientation',
          icon: Icons.screen_rotation_outlined,
          onPressed: hasDevice ? deviceSettings.rotate : null,
        ),
        DashbookIcon(
          key: kHideFrameIcon,
          tooltip: 'Device frame',
          icon: Icons.mobile_off_outlined,
          onPressed: hasDevice ? deviceSettings.toggleDeviceFrame : null,
        ),
        const Spacer(),
        TextButton(onPressed: deviceSettings.reset, child: const Text('Reset')),
      ],
    );
  }
}
