import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/select_device/components/text_scale_factor_slider.dart';
import 'package:dashbook/src/widgets/select_device/device_settings.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

class CustomDevice extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSettings = DeviceSettings.of(context);
    final deviceInfo = deviceSettings.settings.deviceInfo;
    if (deviceInfo == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SizeField(
                label: 'Width',
                initialValue: deviceInfo.screenSize.width,
                onChanged: (width) =>
                    deviceSettings.updateCustomDevice(width: width),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SizeField(
                label: 'Height',
                initialValue: deviceInfo.screenSize.height,
                onChanged: (height) =>
                    deviceSettings.updateCustomDevice(height: height),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const PropertyScaffold(
          label: 'Text scale factor:',
          child: TextScaleFactorSlider(),
        ),
        const SizedBox(height: 12),
        _PlatformPicker(
          selected: deviceInfo.identifier.platform,
          onSelect: (platform) =>
              deviceSettings.updateCustomDevice(platform: platform),
        ),
      ],
    );
  }
}

class _SizeField extends StatelessWidget {
  const new({
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  final String label;
  final double initialValue;
  final ValueChanged<double> onChanged;

  static String? _validate(String? value) {
    if (value == null || value.isEmpty) return 'Value can not be empty';
    final size = double.tryParse(value);
    if (size == null) return 'Input needs to be digits only';
    if (size > 5000) return 'Try to use a value less than 5000';
    if (size < 100) return 'Try to use a value greater than 100';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: '${initialValue.toInt()}',
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: _validate,
      onChanged: (value) {
        if (_validate(value) == null) {
          onChanged(double.parse(value));
        }
      },
      decoration: InputDecoration(labelText: label),
    );
  }
}

class _PlatformPicker extends StatelessWidget {
  const new({required this.selected, required this.onSelect});

  final TargetPlatform selected;
  final ValueChanged<TargetPlatform> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (final platform in [TargetPlatform.android, TargetPlatform.iOS])
          TextButton(
            onPressed: () => onSelect(platform),
            child: Text(
              platform.name,
              style: TextStyle(
                fontWeight: platform == selected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
      ],
    );
  }
}
